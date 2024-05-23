from logging import Logger
import os

import torch
from transformers import AlbertTokenizerFast, AlbertForTokenClassification
import psycopg2
from psycopg2 import sql, Error
from dotenv import load_dotenv
from safetensors.torch import load_file

load_dotenv()

HOST = os.getenv('HOST')
DATABASE = os.getenv('DATABASE')
DBUSERNAME = os.getenv('DBUSERNAME')
PASSWORD = os.getenv('PASSWORD')

class NERModel:

    def __init__(self, device: str, logger: Logger, **kwargs) -> None:
        self.device = device
        
        print("Loading Albert-XXLarge-V2 tokenizer...")
        self.tokenizer = AlbertTokenizerFast.from_pretrained("albert-xxlarge-v2", truncation=True, **kwargs)
        assert self.tokenizer.is_fast is True

        print("Loading Albert-XXLarge-V2 Model...")
        checkpoint_path = "../models/albert-xxlarge-v2-finetuned-ner/checkpoint-1608"

        try:
            model_state_dict = load_file(f"{checkpoint_path}/model.safetensors")
            self.model = AlbertForTokenClassification.from_pretrained("albert-xxlarge-v2", state_dict=model_state_dict, num_labels=4)
        except Exception as e:
            print(f"Failed to load model from {checkpoint_path}, error: {e}")
            print("Ensure the checkpoint directory contains the necessary safetensors model file.")

        self.model.to(self.device)
        self.model.eval()
        
        self.labels = ['I-LF', 'B-AC', 'B-LF', 'B-O']
        self.logger = logger
        
        try:
            self.DB_connection = psycopg2.connect(
                host=HOST,
                database=DATABASE,
                user=DBUSERNAME,
                password=PASSWORD
            )
            cursor = self.DB_connection.cursor()
            cursor.execute("SELECT version();")
            db_version = cursor.fetchone()
            print("Connected to PostgreSQL Server version ", db_version)
            cursor.execute("SELECT current_database();")
            record = cursor.fetchone()
            print("You're connected to database: ", record)    
        except Error as e:
            print("Error while connecting to PostgreSQL", e)
            self.DB_connection = None

    def tag_sequence(self, text):
        tok = self.tokenizer(text,
                             add_special_tokens=True,
                             truncation=True,
                             max_length=512,
                             padding=True,
                             return_token_type_ids=True,
                             return_tensors='pt')

        tok = {key: val.to(self.device) for key, val in tok.items()}

        with torch.no_grad():
            logits = self.model(**tok).logits

        idx = torch.argmax(logits, dim=-1).squeeze().tolist()

        if not isinstance(idx, list):
            idx = [idx]

        pred_labels = [self.labels[i] for i in idx]

        print(text, idx, pred_labels)

        self.logger.info("Logging additional Information", 
                         extra={'user_input': text,
                                'model_prediction': pred_labels})
        
        if self.DB_connection:
            cursor = self.DB_connection.cursor()

            sql_query = """
                INSERT INTO log_data (timestamp, user_input, model_prediction) 
                VALUES (NOW(), %s, %s)
            """

            cursor.execute(sql_query, (text, str(pred_labels)))
            self.DB_connection.commit()
            cursor.close()

        return text, pred_labels

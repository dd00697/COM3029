import argparse
from logging import Logger, basicConfig, INFO

from fastapi import FastAPI
import gradio as gr
import uvicorn

from model import NERModel

# Set up argument parser
parser = argparse.ArgumentParser(description='Start the NER Flask app with specified device.')
parser.add_argument('--device', type=str, default='cpu', help='Device to run the model on (e.g., cpu, cuda, mps)')
args = parser.parse_args()

# Initialize logger
basicConfig(level=INFO)
logger = Logger(name='NERLogger')
ner_model = NERModel(device=args.device, logger=logger)

# Create FastAPI app
app = FastAPI()

# Create Gradio Interface
def tag_text_gradio(text):
    text, pred_labels = ner_model.tag_sequence(text)
    return text, pred_labels

ui = gr.Interface(
    fn=tag_text_gradio,
    inputs=gr.Textbox(label="Submit a text for tagging."),
    outputs=[gr.Textbox(label="Text"), gr.Textbox(label="Labels")],
    allow_flagging="never"
)

# Mount Gradio app on FastAPI
app = gr.mount_gradio_app(app, ui, path="/")

# API endpoint for prediction
@app.post('/tag')
async def tag_text(data: dict):
    text = data.get('text', '')

    if not text:
        return {'error': 'No text provided'}

    text, pred_labels = ner_model.tag_sequence(text)
    return {
        'text': text,
        'pred_labels': pred_labels,
    }

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=8000)

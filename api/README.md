# NLP COM3029 Coursework 2 - NER

## Description
This is a basic application & interface to run a custom fine-tuned ALBERT XXL V2 model for NER. The UI is a gradio app with a FastAPI backend.

## Set Up

1. Make sure you have PostgreSQL installed, a username and password. Create a DB called ner_db.

2. Run the command ```python -m venv ~/nlp``` in terminal to create a virtual environment called nlp.

3. Run ```source ~/nlp/bin/activate``` to activate the environment, then navigate to the project root directory ```api/```.

4. Run ```pip install -r requirements.txt```.

5. Replace the ```DBUSERNAME``` and ```PASSWORD``` values in the .env file with your corresponding credentials.

6. Run ```sh run_app.sh [DEVICE]``` replacing ```[DEVICE]``` with the torch compatible device you want to run the model on. Default is ```cpu```.

7. Navigate to ```https:localhost:8000``` to test.

All should be working.
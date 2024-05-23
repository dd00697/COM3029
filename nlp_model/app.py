from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    prediction = "testtttt"
    return jsonify({'prediction': prediction})

#l
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

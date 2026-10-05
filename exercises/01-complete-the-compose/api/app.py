from flask import Flask, jsonify, request

app = Flask(__name__)

@app.get('/health')
def health():
    return jsonify(status='ok', service='api')

@app.post('/echo')
def echo():
    data = request.get_json(silent=True)
    message = data.get('message') if isinstance(data, dict) else None
    if not isinstance(message, str) or not message.strip():
        return jsonify(error='Informe uma mensagem não vazia em JSON.'), 400
    return jsonify(message=message)

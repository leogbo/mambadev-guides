### main.py
from flask import Flask, request, jsonify
import os

app = Flask(__name__)

AUTH_TOKEN = os.getenv("INSIGHT_API_TOKEN")

@app.route("/insights", methods=["POST"])
def receive_insight():
    token = request.headers.get("Authorization")
    if not token or token != f"Bearer {AUTH_TOKEN}":
        return jsonify({"error": "Unauthorized"}), 401

    data = request.get_json()
    print("Insight received:", data)

    # Aqui você pode salvar em banco, enviar pra outro serviço, etc.
    return jsonify({"status": "success", "message": "Insight received"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)




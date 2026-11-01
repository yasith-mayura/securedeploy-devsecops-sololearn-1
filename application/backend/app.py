import os
import psycopg
from flask import Flask, jsonify

app = Flask(__name__)

def database_connection():
    return psycopg.connect(
        host=os.getenv("DB_HOST", "postgres"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "securedeploy"),
        user=os.getenv("DB_USER", "securedeploy"),
        password=os.environ["DB_PASSWORD"],
        connect_timeout=3
    )

@app.get("/")
def home():
    return jsonify({
        "application": "SecureDeploy API",
        "version": os.getenv("APP_VERSION", "development"),
        "status": "running"
    })

@app.get("/healthz")
def health():
    return jsonify({"status": "healthy"}), 200

@app.get("/readyz")
def readiness():
    try:
        with database_connection() as conn:
            conn.execute("SELECT 1")
        return jsonify({"status": "ready"}), 200
    except Exception:
        return jsonify({"status": "not ready"}), 503

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000) # nosec B104

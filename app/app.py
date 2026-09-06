import json
import logging
import os
from datetime import datetime, timezone

from flask import Flask, jsonify, request

app = Flask(__name__)

ENVIRONMENT = os.getenv("APP_ENV", "development")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "level": record.levelname,
            "message": record.getMessage(),
            "environment": ENVIRONMENT,
            "version": APP_VERSION,
        }
        return json.dumps(log_record)


handler = logging.StreamHandler()
handler.setFormatter(JsonFormatter())

app.logger.handlers.clear()
app.logger.addHandler(handler)
app.logger.setLevel(logging.INFO)


@app.before_request
def log_request():
    app.logger.info(
        f"{request.method} {request.path} from {request.remote_addr}"
    )


@app.route("/")
def home():
    return jsonify(
        service="lawal-cloud-platform",
        message="Production Cloud Platform API",
        environment=ENVIRONMENT,
        version=APP_VERSION,
    )


@app.route("/health")
def health():
    return jsonify(
        status="healthy",
        environment=ENVIRONMENT,
        version=APP_VERSION,
    ), 200


@app.route("/version")
def version():
    return jsonify(version=APP_VERSION)


@app.route("/environment")
def environment():
    return jsonify(environment=ENVIRONMENT)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

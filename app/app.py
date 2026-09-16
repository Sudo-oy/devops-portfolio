"""Reference web service used to demonstrate the delivery platform.

Endpoints:
  GET /         service information
  GET /healthz  liveness probe
  GET /readyz   readiness probe
  GET /metrics  Prometheus metrics
"""

from __future__ import annotations

import os
import time

from flask import Flask, Response, g, jsonify, request
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest

REQUESTS = Counter("http_requests_total", "HTTP requests handled", ["method", "endpoint", "status"])
LATENCY = Histogram(
    "http_request_duration_seconds", "HTTP request latency in seconds", ["endpoint"]
)


def create_app() -> Flask:
    app = Flask(__name__)

    @app.before_request
    def _start_timer() -> None:
        g.start = time.perf_counter()

    @app.after_request
    def _record_metrics(response: Response) -> Response:
        endpoint = request.url_rule.rule if request.url_rule else "unknown"
        if endpoint != "/metrics":
            LATENCY.labels(endpoint).observe(time.perf_counter() - g.start)
            REQUESTS.labels(request.method, endpoint, str(response.status_code)).inc()
        return response

    @app.get("/")
    def index() -> Response:
        return jsonify(
            service="devops-portfolio",
            environment=os.getenv("APP_ENV", "development"),
            version=os.getenv("APP_VERSION", "dev"),
        )

    @app.get("/healthz")
    def healthz() -> Response:
        return jsonify(status="ok")

    @app.get("/readyz")
    def readyz() -> Response:
        return jsonify(status="ready")

    @app.get("/metrics")
    def metrics() -> Response:
        return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

    return app


app = create_app()

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=int(os.getenv("PORT", "8080")))

from __future__ import annotations

import pytest
from flask.testing import FlaskClient

from app import create_app


@pytest.fixture
def client() -> FlaskClient:
    return create_app().test_client()


def test_index_reports_environment(client: FlaskClient, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("APP_ENV", "staging")
    monkeypatch.setenv("APP_VERSION", "1.2.3")
    body = client.get("/").get_json()
    assert body == {"service": "devops-portfolio", "environment": "staging", "version": "1.2.3"}


@pytest.mark.parametrize("path", ["/healthz", "/readyz"])
def test_probes_return_200(client: FlaskClient, path: str) -> None:
    assert client.get(path).status_code == 200


def test_metrics_expose_request_counter(client: FlaskClient) -> None:
    client.get("/healthz")
    response = client.get("/metrics")
    assert response.status_code == 200
    assert b'http_requests_total{endpoint="/healthz",method="GET",status="200"}' in response.data


def test_unknown_route_returns_404(client: FlaskClient) -> None:
    assert client.get("/does-not-exist").status_code == 404

def test_unknown_route_metrics_use_unknown_endpoint_label(client: FlaskClient) -> None:
    client.get("/does-not-exist")
    response = client.get("/metrics")
    assert response.status_code == 200
    assert b'http_requests_total{endpoint="unknown",method="GET",status="404"}' in response.data

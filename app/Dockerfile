# ---------------------
# 🏗️ Stage 1: Build
# ---------------------
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# ---------------------
# 🚀 Stage 2: Runtime
# ---------------------
FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .

ENV PATH=/root/.local/bin:$PATH
ENV APP_ENV=production
ENV PORT=80

EXPOSE 80
CMD ["python", "app.py"]

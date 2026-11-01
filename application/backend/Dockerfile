
# Stage 1: Build dependencies
FROM cgr.dev/chainguard/python:latest-dev AS builder

WORKDIR /build

COPY requirements.txt .
# Upgrade setuptools in the base Python environment
RUN python -m pip install --no-cache-dir \
    --upgrade "setuptools>=78.1.1"
# Create virtual environment in a writable directory
RUN python -m venv /home/nonroot/venv

ENV PATH="/home/nonroot/venv/bin:$PATH"

# Install dependencies and fix setuptools vulnerability
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade "setuptools>=78.1.1"

# Stage 2: Production runtime
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/home/nonroot/venv/bin:$PATH"

# Copy installed dependencies
COPY --from=builder --chown=65532:65532 \
    /home/nonroot/venv /home/nonroot/venv

# Copy application
COPY --chown=65532:65532 app.py .

USER 65532

EXPOSE 5000

ENTRYPOINT []

CMD ["gunicorn", \
     "--bind", "0.0.0.0:5000", \
     "--workers", "2", \
     "--access-logfile", "-", \
     "--error-logfile", "-", \
     "app:app"]


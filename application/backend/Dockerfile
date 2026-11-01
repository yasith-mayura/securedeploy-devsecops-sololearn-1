
# Stage 1: Install application dependencies
FROM cgr.dev/chainguard/python:latest-dev AS builder
WORKDIR /build

COPY requirements.txt .

RUN python -m venv /venv && \
    /venv/bin/pip install --no-cache-dir \
    -r requirements.txt


# Stage 2: Minimal production runtime
FROM cgr.dev/chainguard/python:latest AS runtime

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/venv/bin:${PATH}"

# Copy only installed dependencies
COPY --from=builder /venv /venv

# Copy application
COPY --chown=65532:65532 app.py .

# Run as non-root user
USER 65532

EXPOSE 5000

CMD ["gunicorn", \
     "--bind", "0.0.0.0:5000", \
     "--workers", "2", \
     "--access-logfile", "-", \
     "--error-logfile", "-", \
     "app:app"]


# ---------- Stage 1: builder (install deps into a venv) ----------
FROM python:3.12-slim AS builder

# Avoid interactive prompts & speed up installs
ENV PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create and activate a virtualenv at /opt/venv
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy only dependency metadata first (layer caching)
# If you only need Flask, we'll just install it directly.
# If you later add requirements.txt, uncomment the COPY+pip lines.
# COPY requirements.txt .
# RUN pip install -r requirements.txt

# For your current case (Flask only):
RUN pip install --upgrade pip && pip install flask

# ---------- Stage 2: runtime (tiny final image) ----------
FROM python:3.12-slim

# Copy the virtualenv from builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# App code
WORKDIR /app
COPY app.py /app/app.py

# Flask settings (env vars)
ENV FLASK_APP=/app/app.py \
    FLASK_RUN_HOST=0.0.0.0 \
    FLASK_RUN_PORT=8080

EXPOSE 8080

# Use CMD for default args (easy to override)
CMD ["flask", "run"]

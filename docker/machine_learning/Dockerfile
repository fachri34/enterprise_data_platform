FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY docker/machine_learning/requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt

COPY pipeline/feature_store /app/feature_store
COPY pipeline/dags/machine_learning /app/machine_learning

WORKDIR /app

CMD ["python", "--version"]
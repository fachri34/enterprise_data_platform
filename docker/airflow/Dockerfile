FROM apache/airflow:2.10.2

COPY requirements.txt /tmp/requirements.txt
COPY dbt-requirements.txt /tmp/dbt-requirements.txt

COPY ./variables_and_connections /init/variables_and_connections

RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN python -m virtualenv /opt/airflow/dbt_venv && \
    /opt/airflow/dbt_venv/bin/pip install \
    --no-cache-dir \
    -r /tmp/dbt-requirements.txt

# Tambahkan ini
ENV DBT_VENV=/opt/airflow/dbt_venv
ENV PATH="${DBT_VENV}/bin:${PATH}"

RUN dbt --version

USER airflow
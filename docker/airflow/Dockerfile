FROM apache/airflow:2.10.2

# Copy dependency files
COPY requirements.txt /tmp/requirements.txt
COPY dbt-requirements.txt /tmp/dbt-requirements.txt

COPY ./variables_and_connections /init/variables_and_connections
# Install Airflow-related dependencies
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Create isolated dbt environment
RUN python -m virtualenv /opt/airflow/dbt_venv && \
    /opt/airflow/dbt_venv/bin/pip install \
    --no-cache-dir \
    -r /tmp/dbt-requirements.txt

# Optional: verify installation
RUN /opt/airflow/dbt_venv/bin/dbt --version

# Switch back to airflow user
USER airflow
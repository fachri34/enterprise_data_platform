from airflow.decorators import task_group
from airflow.datasets import Dataset
from airflow.models import Variable
from airflow.operators.python import PythonOperator
import os
from staging.tasks.extract import extract
from staging.tasks.load import load

GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID")


@task_group(group_id="extract")
def extract_task(incremental: bool):

    tables = Variable.get(
        "ADVENTUREWORKS_STAGING_TABLES",
        deserialize_json=True,
    )

    for table_name, info in tables.items():

        schema = info[0]

        PythonOperator(
            task_id=f"extract_{schema}_{table_name}",
            python_callable=extract,
            op_kwargs={
                "schema": schema,
                "table_name": table_name,
                "incremental": incremental,
            },
            outlets=[
                Dataset(
                    f"s3://adv-db/{schema}/{table_name}/"
                )
            ],
            trigger_rule="none_failed",
        )


@task_group(group_id="load")
def load_task(incremental: bool):

    tables = Variable.get(
        "ADVENTUREWORKS_STAGING_TABLES",
        deserialize_json=True,
    )

    for table_name, info in tables.items():

        schema = info[0]

        PythonOperator(
            task_id=f"load_{schema}_{table_name}",
            python_callable=load,
            op_kwargs={
                "dataset": "adv-db",
                "schema": schema,
                "table_name": table_name,
                "incremental": incremental,
            },
            inlets=[Dataset(f"s3://adv-db/{schema}/{table_name}/")],
            outlets=[Dataset(f"bigquery://{GCP_PROJECT_ID}/raw/{table_name}")],
            trigger_rule="none_failed",
        )
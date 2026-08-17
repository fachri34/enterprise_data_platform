from airflow.decorators import task_group
from airflow.operators.python import PythonOperator
from reverse_etl.tasks.extract import Extract
from reverse_etl.tasks.load import Load

import pandas as pd


def extract_customer(**context):
    """
    Extract customer intelligence data
    from BigQuery analytics layer.
    """

    df = Extract.extract_customer(**context)

    if df is not None and not df.empty:
        return df.to_dict(orient="records")

    return None


def extract_inventory(**context):
    """
    Extract inventory reorder recommendation data
    from BigQuery analytics layer.
    """

    df = Extract.extract_inventory(**context)

    if df is not None and not df.empty:
        return df.to_dict(orient="records")

    return None


def load_customer(**context):
    """
    Load customer intelligence data
    into PostgreSQL operational database.
    """

    ti = context["task_instance"]

    data = ti.xcom_pull(
        task_ids="reverse_etl.extract_customer"
    )

    if data is None or len(data) == 0:
        return None

    df = pd.DataFrame(data)

    Load.load_data(
        df=df,
        target_table="customer_intelligence",
        conflict_columns=["customer_id"],
        schema="operational",   
        **context
    )


def load_inventory(**context):
    """
    Load inventory reorder recommendation data
    into PostgreSQL operational database.
    """

    ti = context["task_instance"]

    data = ti.xcom_pull(
        task_ids="reverse_etl.extract_inventory"
    )

    if data is None or len(data) == 0:
        return None

    df = pd.DataFrame(data)

    Load.load_data(
        df=df,
        target_table="inventory_reorder",
        conflict_columns=["product_id", "location_id"],
        schema="operational",   
        **context
    )


@task_group(group_id="reverse_etl")
def main():

    extract_customer_task = PythonOperator(
        task_id="extract_customer",
        python_callable=extract_customer,
    )

    extract_inventory_task = PythonOperator(
        task_id="extract_inventory",
        python_callable=extract_inventory,
    )

    load_customer_task = PythonOperator(
        task_id="load_customer",
        python_callable=load_customer,
    )

    load_inventory_task = PythonOperator(
        task_id="load_inventory",
        python_callable=load_inventory,
    )

    # Customer Reverse ETL
    extract_customer_task >> load_customer_task

    # Inventory Reverse ETL
    extract_inventory_task >> load_inventory_task
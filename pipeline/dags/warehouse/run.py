from pendulum import datetime
from warehouse.main import create_dbt_task_group
from airflow.decorators import dag
from airflow.operators.trigger_dagrun import TriggerDagRunOperator


@dag(
    dag_id="adventureworks_warehouse",
    description="AdventureWorks Warehouse Pipeline",
    start_date=datetime(2026, 7, 8, tz="Asia/Jakarta"),
    schedule=None,
    catchup=False,
)
def adventureworks_warehouse():

    dbt_staging = create_dbt_task_group(
        group_id="dbt_staging",
        select_path="path:models/staging",
    )
    
    dbt_intermediate = create_dbt_task_group(
        group_id="dbt_intermediate",
        select_path="path:models/intermediate",
    )
    
    dbt_marts = create_dbt_task_group(
        group_id="dbt_marts",
        select_path="path:models/marts",
    )
    
    dbt_analytics = create_dbt_task_group(
        group_id="dbt_analytics",
        select_path="path:models/analytics",
    )
    
    trigger_reverse_etl = TriggerDagRunOperator(
        task_id="trigger_reverse_etl",
        trigger_dag_id="reverse_etl"
    )

    dbt_staging >> dbt_intermediate >> dbt_marts >> dbt_analytics >> trigger_reverse_etl

adventureworks_warehouse()
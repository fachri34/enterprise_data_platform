from pendulum import datetime
from warehouse.main import main
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
    
    trigger_reverse_etl = TriggerDagRunOperator(
        task_id="trigger_reverse_etl",
        trigger_dag_id="reverse_etl"
    )    
    
    main() >> trigger_reverse_etl

adventureworks_warehouse()
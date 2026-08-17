from airflow.decorators import dag
from airflow.models import Variable
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from pendulum import datetime
from staging.tasks.main import extract_task, load_task

# Define the DAG with its properties
@dag(
    dag_id='adventureworks_staging',
    description='Extract data and load into staging area',
    start_date=datetime(2026, 7, 8, tz="Asia/Jakarta"),
    schedule="@daily",
    catchup=False,
)
def adventureworks_staging():
    """
    DAG function to extract data and load it into the staging area.
    It also triggers the next DAG for loading data into the warehouse.
    """
    # Get the incremental mode from Airflow Variables
    incremental_mode = Variable.get('ADVENTUREWORKS_STAGING_INCREMENTAL_MODE')
    incremental_mode = eval(incremental_mode)  # Convert string to boolean
    
    trigger_warehouse_dag = TriggerDagRunOperator(
        task_id='trigger_warehouse_pipeline',
        trigger_dag_id='adventureworks_warehouse',
        trigger_rule='none_failed',  # Trigger even if the current DAG fails
    )

    # Define the task dependencies
    extract_task(incremental=incremental_mode) >> load_task(incremental=incremental_mode) >> trigger_warehouse_dag

# Instantiate the DAG
adventureworks_staging()
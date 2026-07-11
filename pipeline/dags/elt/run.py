from airflow.decorators import dag
from airflow.models import Variable
from pendulum import datetime
from elt.staging_pipeline.tasks.main import extract_task, load_task

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

    # Define the task dependencies
    extract_task(incremental=incremental_mode) >> load_task(incremental=incremental_mode) 

# Instantiate the DAG
adventureworks_staging()
from airflow.decorators import dag
from pendulum import datetime
from reverse_etl.tasks.main import main

# Define the DAG with its properties
@dag(
    dag_id='reverse_etl',
    description='Extract data and load into operational database',
    start_date=datetime(2024, 9, 1, tz="Asia/Jakarta"),
    schedule=None,
    catchup=False,
)
def reverse_etl():
    """
    DAG function to Extract data and load operational database
    """
    main()

dag = reverse_etl()
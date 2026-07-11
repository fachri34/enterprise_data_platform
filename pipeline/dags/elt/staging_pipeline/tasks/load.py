import os
from airflow.exceptions import AirflowSkipException
from helpers.bigquery import BigQuery
from helpers.s3 import S3


def load(
    dataset: str,
    schema: str,
    table_name: str,
    incremental: bool,
    **kwargs,
):
    """
    Load CSV file from MinIO into BigQuery.
    """

    project_id = os.getenv("GCP_PROJECT_ID")

    if incremental:
        key = f"{dataset}/{schema}/{table_name}/latest.csv"
        write_disposition = "WRITE_APPEND"
    else:
        key = f"{dataset}/{schema}/{table_name}/full_data.csv"
        write_disposition = "WRITE_TRUNCATE"

    # Cek apakah object tersedia
    if not S3.exists(
        aws_conn_id="s3-conn",
        bucket_name="adv-bucket",
        key=key,
    ):
        raise AirflowSkipException(
            f"File {key} tidak ditemukan di MinIO."
        )

    # Read CSV
    df = S3.pull(
        aws_conn_id="s3-conn",
        bucket_name="adv-bucket",
        key=key,
    )

    bq = BigQuery()

    bq.load_dataframe(
        dataframe=df,
        project_id=project_id,
        dataset_id="adv_staging",
        table_name=table_name,
        write_disposition=write_disposition,
    )

    print(f"{table_name} loaded successfully.")
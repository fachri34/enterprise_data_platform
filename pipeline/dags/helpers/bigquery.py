from google.cloud import bigquery


class BigQuery:
    """
    Helper class for Google BigQuery operations.
    """

    def __init__(self):
        self.client = bigquery.Client()

    def load_dataframe(self, dataframe, project_id: str, dataset_id: str, table_name: str, write_disposition: str = "WRITE_TRUNCATE",):
        """
        Load dataframe into BigQuery.
        """

        table_id = f"{project_id}.{dataset_id}.{table_name}"

        job_config = bigquery.LoadJobConfig(
            autodetect=True,
            write_disposition=write_disposition,
        )

        job = self.client.load_table_from_dataframe(
            dataframe=dataframe,
            destination=table_id,
            job_config=job_config,
        )

        job.result()

        table = self.client.get_table(table_id)

        print(
            f"Loaded {table.num_rows} rows into {table.project}.{table.dataset_id}.{table.table_id}"
        )
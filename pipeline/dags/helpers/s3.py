from airflow.providers.amazon.aws.hooks.s3 import S3Hook
import pandas as pd
from io import StringIO


class S3:

    @staticmethod
    def push(aws_conn_id, bucket_name, key, string_data):
        hook = S3Hook(aws_conn_id=aws_conn_id)
        hook.load_string(
            string_data=string_data,
            key=key,
            bucket_name=bucket_name,
            replace=True,
        )

    @staticmethod
    def pull(aws_conn_id, bucket_name, key):
        hook = S3Hook(aws_conn_id=aws_conn_id)

        obj = hook.read_key(
            key=key,
            bucket_name=bucket_name,
        )

        return pd.read_csv(StringIO(obj))

    @staticmethod
    def exists(aws_conn_id, bucket_name, key):
        hook = S3Hook(aws_conn_id=aws_conn_id)

        return hook.check_for_key(
            key=key,
            bucket_name=bucket_name,
        )
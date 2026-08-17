from airflow.providers.postgres.hooks.postgres import PostgresHook
from pangres import upsert
from sqlalchemy import create_engine


class Load:

    @staticmethod
    def load_data(df,target_table,conflict_columns,schema="operational",**context):
        """
        Upsert DataFrame into PostgreSQL operational database.

        Parameters
        ----------
        df : pandas.DataFrame
            Data extracted from BigQuery analytics.

        target_table : str
            Target PostgreSQL table.

        conflict_columns : list
            Columns used as conflict key for UPSERT.

        schema : str
            PostgreSQL target schema.
        """

        if df is None or df.empty:
            return

        try:
            postgres_hook = PostgresHook(postgres_conn_id="adv-db")
            postgres_uri = postgres_hook.get_uri()
            engine = create_engine(postgres_uri)
            

            df = df.set_index(conflict_columns)

            upsert(
                con=engine,
                df=df,
                table_name=target_table,
                schema=schema,
                if_row_exists="update",
            )

        except Exception as e:
            raise Exception(
                f"Error upserting data into "
                f"{schema}.{target_table}: {str(e)}"
            )
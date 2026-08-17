from airflow.providers.google.cloud.hooks.bigquery import BigQueryHook


class Extract:

    @staticmethod
    def extract_customer(**context):
        """
        Extract customer intelligence data
        from BigQuery analytics layer.
        """

        try:
            bigquery_hook = BigQueryHook(
                gcp_conn_id="google_cloud_default",
                use_legacy_sql=False,
            )

            query = """
                SELECT
                    s.customer_id,
                    s.customer_name,
                    s.customer_segment,
                    s.rfm_score,

                    c.total_sales,
                    c.total_profit,
                    c.average_order_value,
                    c.estimated_annual_customer_value,
                    c.customer_value_segment,

                    r.recency_days,
                    r.churn_risk,
                    r.churn_risk_score

                FROM `adventureworks-pipeline-501611.analytics.customer_segmentation` s

                LEFT JOIN `adventureworks-pipeline-501611.analytics.customer_clv` c
                    ON s.customer_id = c.customer_id

                LEFT JOIN `adventureworks-pipeline-501611.analytics.customer_churn_risk` r
                    ON s.customer_id = r.customer_id
            """

            df = bigquery_hook.get_pandas_df(query)

            return df

        except Exception as e:
            raise Exception(
                f"Error extracting customer intelligence: {str(e)}"
            )


    @staticmethod
    def extract_inventory(**context):
        """
        Extract inventory reorder recommendation
        from BigQuery analytics layer.
        """

        try:
            bigquery_hook = BigQueryHook(
                gcp_conn_id="google_cloud_default",
                use_legacy_sql=False,
            )

            query = """
                SELECT
                    product_id,
                    product_name,
                    location_id,
                    location_name,
                    quantity_on_hand,
                    total_quantity_sold,
                    net_sales,
                    reorder_priority,
                    reorder_required

                FROM `adventureworks-pipeline-501611.analytics.product_reorder_recommendation`
            """

            df = bigquery_hook.get_pandas_df(query)

            return df

        except Exception as e:
            raise Exception(
                f"Error extracting inventory reorder data: {str(e)}"
            )
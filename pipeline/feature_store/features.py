from datetime import timedelta
from feast import BigQuerySource, FeatureView, Field
from feast.types import Int64, Float64
from entities import customer


customer_churn_source = BigQuerySource(
    name="customer_churn_source",
    table="adventureworks-pipeline-501611.features.customer_churn_features",
    timestamp_field="event_timestamp",
)


customer_churn_features = FeatureView(
    name="customer_churn_features",
    entities=[customer],
    ttl=timedelta(days=3650),
    schema=[
        Field(
            name="customer_recency",
            dtype=Int64,
        ),
        Field(
            name="customer_frequency",
            dtype=Int64,
        ),
        Field(
            name="customer_monetary",
            dtype=Float64,
        ),
        Field(
            name="orders_30d",
            dtype=Int64,
        ),
        Field(
            name="orders_90d",
            dtype=Int64,
        ),
        Field(
            name="avg_order_value",
            dtype=Float64,
        ),
    ],
    source=customer_churn_source,
)
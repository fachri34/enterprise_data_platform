from feast import Entity, ValueType


customer = Entity(
    name="customer",
    join_keys=["customer_key"],
    value_type=ValueType.STRING,
    description="AdventureWorks customer entity for churn prediction",
)
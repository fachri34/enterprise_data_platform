CREATE SCHEMA IF NOT EXISTS operational;

CREATE TABLE operational.customer_intelligence (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(255),

    customer_segment VARCHAR(50),
    rfm_score INTEGER,

    total_sales NUMERIC(18,2),
    total_profit NUMERIC(18,2),
    average_order_value NUMERIC(18,2),

    estimated_annual_customer_value NUMERIC(18,2),
    customer_value_segment VARCHAR(50),

    recency_days INTEGER,
    churn_risk VARCHAR(20),
    churn_risk_score INTEGER,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE operational.inventory_reorder (
    product_id VARCHAR(50),
    product_name VARCHAR(255),

    location_id VARCHAR(50),
    location_name VARCHAR(255),

    quantity_on_hand NUMERIC(18,2),
    total_quantity_sold NUMERIC(18,2),
    net_sales NUMERIC(18,2),

    reorder_priority VARCHAR(20),
    reorder_required BOOLEAN,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (product_id, location_id)
);
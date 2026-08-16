with customer as (

    select *
    from {{ ref('customer_summary') }}

),

analysis_date as (

    select
        max(last_order_date_key) as max_date_key

    from customer

    where last_order_date_key is not null

),

customer_recency as (

    select

        c.customer_key,
        c.customer_id,
        c.customer_name,
        c.total_orders,
        c.total_sales,
        c.total_profit,

        c.last_order_date_key,

        date_diff(
            parse_date(
                '%Y%m%d',
                cast(a.max_date_key as string)
            ),
            parse_date(
                '%Y%m%d',
                cast(c.last_order_date_key as string)
            ),
            day
        ) as recency_days

    from customer c

    cross join analysis_date a

    where c.last_order_date_key is not null

)

select

    customer_key,
    customer_id,
    customer_name,
    total_orders,
    total_sales,
    total_profit,

    last_order_date_key,
    recency_days,

    case

        when recency_days >= 180
             and total_orders <= 2
            then 'High'

        when recency_days >= 90
            then 'Medium'

        else 'Low'

    end as churn_risk,

    case

        when recency_days >= 180
             and total_orders <= 2
            then 3

        when recency_days >= 90
            then 2

        else 1

    end as churn_risk_score

from customer_recency
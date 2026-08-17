with orders as (

    select
        f.customer_key,
        f.sales_order_id,
        d.date_actual as order_date,
        f.net_sales

    from {{ ref('fact_order') }} f

    inner join {{ ref('dim_date') }} d
        on f.order_date_key = d.date_key

    where f.customer_key is not null

),

dataset_bounds as (

    select
        min(order_date) as min_order_date,
        max(order_date) as max_order_date

    from orders

),

customer_first_order as (

    select
        customer_key,
        min(order_date) as first_order_date

    from orders

    group by customer_key

),

observation_dates as (

    select
        d.date_actual as event_date

    from {{ ref('dim_date') }} d

    cross join dataset_bounds b

    where d.is_month_start = true

        -- Harus tersedia future 90-day window
        and d.date_actual <= date_sub(
            b.max_order_date,
            interval 90 day
        )

),

customer_snapshots as (

    select
        c.customer_key,
        o.event_date

    from customer_first_order c

    inner join observation_dates o

        on o.event_date >= date_add(
            date_trunc(
                c.first_order_date,
                month
            ),
            interval 1 month
        )

),

features as (

    select

        cs.customer_key,

        cast(
            cs.event_date as timestamp
        ) as event_timestamp,

        -- Recency
        date_diff(
            cs.event_date,
            max(o.order_date),
            day
        ) as customer_recency,

        -- Lifetime frequency
        count(
            distinct o.sales_order_id
        ) as customer_frequency,

        -- Lifetime monetary
        coalesce(
            sum(o.net_sales),
            0
        ) as customer_monetary,

        -- Orders in previous 30 days
        count(
            distinct case
                when o.order_date >= date_sub(
                    cs.event_date,
                    interval 30 day
                )
                then o.sales_order_id
            end
        ) as orders_30d,

        -- Orders in previous 90 days
        count(
            distinct case
                when o.order_date >= date_sub(
                    cs.event_date,
                    interval 90 day
                )
                then o.sales_order_id
            end
        ) as orders_90d

    from customer_snapshots cs

    left join orders o

        on cs.customer_key = o.customer_key

        -- Point-in-time condition
        and o.order_date < cs.event_date

    group by
        cs.customer_key,
        cs.event_date

)

select

    customer_key,

    event_timestamp,

    customer_recency,

    customer_frequency,

    customer_monetary,

    orders_30d,

    orders_90d,

    safe_divide(
        customer_monetary,
        customer_frequency
    ) as avg_order_value

from features
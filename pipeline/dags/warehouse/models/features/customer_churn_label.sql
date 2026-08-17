with features as (

    select
        customer_key,
        event_timestamp

    from {{ ref('customer_churn_features') }}

),

orders as (

    select
        f.customer_key,
        f.sales_order_id,
        d.date_actual as order_date

    from {{ ref('fact_order') }} f

    inner join {{ ref('dim_date') }} d
        on f.order_date_key = d.date_key

    where f.customer_key is not null

),

labels as (

    select

        f.customer_key,

        f.event_timestamp,

        count(
            distinct case
                when o.order_date >= date(f.event_timestamp)
                and o.order_date < date_add(
                    date(f.event_timestamp),
                    interval 90 day
                )
                then o.sales_order_id
            end
        ) as future_orders

    from features f

    left join orders o
        on f.customer_key = o.customer_key

    group by
        f.customer_key,
        f.event_timestamp

)

select

    customer_key,

    event_timestamp,

    case
        when future_orders = 0 then 1
        else 0
    end as churn_90d

from labels
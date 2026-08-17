with customer as (

    select *
    from {{ ref('customer_summary') }}

),

max_date as (

    select
        max(last_order_date_key) as analysis_date_key

    from customer

    where last_order_date_key is not null

),

rfm as (

    select

        c.customer_key,
        c.customer_id,
        c.customer_name,

        c.total_orders,
        c.total_sales,
        c.total_profit,
        c.total_items,

        c.first_order_date_key,
        c.last_order_date_key,

        safe_divide(
            c.total_sales,
            c.total_orders
        ) as average_order_value,

        date_diff(
            parse_date('%Y%m%d', cast(m.analysis_date_key as string)),
            parse_date('%Y%m%d', cast(c.last_order_date_key as string)),
            day
        ) as recency_days

    from customer c

    cross join max_date m

    where c.last_order_date_key is not null

),

rfm_score as (

    select

        *,

        ntile(5) over (
            order by recency_days desc
        ) as recency_score,

        ntile(5) over (
            order by total_orders
        ) as frequency_score,

        ntile(5) over (
            order by total_sales
        ) as monetary_score

    from rfm

)

select

    customer_key,
    customer_id,
    customer_name,
    total_orders,
    total_sales,
    total_profit,
    total_items,
    first_order_date_key,
    last_order_date_key,
    recency_days,
    average_order_value,
    recency_score,
    frequency_score,
    monetary_score,

    (
        recency_score
        + frequency_score
        + monetary_score
    ) as rfm_score,

    case

        when recency_score >= 4
             and frequency_score >= 4
             and monetary_score >= 4
            then 'Platinum'

        when recency_score >= 3
             and frequency_score >= 3
             and monetary_score >= 3
            then 'Gold'

        when recency_score >= 2
             and frequency_score >= 2
            then 'Silver'

        else 'Bronze'

    end as customer_segment

from rfm_score
with fact as (

    select *
    from {{ ref('fact_order') }}

),

customer as (

    select *
    from {{ ref('dim_customer') }}

)

select

    c.customer_key,
    c.customer_id,

    count(distinct f.sales_order_id) as total_orders,

    sum(f.order_quantity) as total_quantity,

    sum(f.net_sales) as total_revenue,

    sum(f.total_cost) as total_cost,

    sum(f.profit) as total_profit,

    safe_divide(
        sum(f.profit),
        sum(f.net_sales)
    ) as profit_margin,

    safe_divide(
        sum(f.net_sales),
        count(distinct f.sales_order_id)
    ) as average_order_value

from fact f

left join customer c
    on f.customer_key = c.customer_key

group by

    c.customer_key,
    c.customer_id
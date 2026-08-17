with fact as (

    select *
    from {{ ref('fact_order') }}

),

product as (

    select *
    from {{ ref('dim_product') }}

)

select

    p.product_key,
    p.product_id,
    p.product_name,

    sum(f.order_quantity) as total_quantity,

    count(distinct f.sales_order_id) as total_orders,

    sum(f.net_sales) as total_revenue,

    sum(f.total_cost) as total_cost,

    sum(f.profit) as total_profit,

    safe_divide(
        sum(f.profit),
        sum(f.net_sales)
    ) as profit_margin

from fact f

left join product p
    on f.product_key = p.product_key

group by

    p.product_key,
    p.product_id,
    p.product_name
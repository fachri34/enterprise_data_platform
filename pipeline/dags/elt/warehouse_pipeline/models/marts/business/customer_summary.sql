with customer_sales as (

    select
        customer_key,

        count(distinct sales_order_id) as total_orders,
        sum(net_sales) as total_sales,
        sum(profit) as total_profit,
        sum(order_quantity) as total_items,

        min(order_date_key) as first_order_date_key,
        max(order_date_key) as last_order_date_key

    from {{ ref('fact_order') }}

    group by customer_key

),

customer as (

    select
        customer_key,
        customer_id,
        customer_name

    from {{ ref('dim_customer') }}

)

select

    c.customer_key,
    c.customer_id,
    c.customer_name,

    coalesce(s.total_orders, 0) as total_orders,
    coalesce(s.total_sales, 0) as total_sales,
    coalesce(s.total_profit, 0) as total_profit,
    coalesce(s.total_items, 0) as total_items,

    s.first_order_date_key,
    s.last_order_date_key,

    safe_divide(
        coalesce(s.total_profit, 0),
        coalesce(s.total_sales, 0)
    ) as profit_margin,

    safe_divide(
        coalesce(s.total_sales, 0),
        coalesce(s.total_orders, 0)
    ) as average_order_value

from customer c

left join customer_sales s
    on c.customer_key = s.customer_key
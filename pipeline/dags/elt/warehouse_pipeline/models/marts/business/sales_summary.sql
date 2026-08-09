with fact as (

    select *
    from {{ ref('fact_order') }}

),

summary as (

    select

        count(distinct sales_order_id) as total_orders,

        sum(order_quantity) as total_quantity,

        sum(net_sales) as total_revenue,

        sum(total_cost) as total_cost,

        sum(profit) as total_profit,

        safe_divide(
            sum(profit),
            sum(net_sales)
        ) as profit_margin,

        safe_divide(
            sum(net_sales),
            count(distinct sales_order_id)
        ) as average_order_value

    from fact

)

select *

from summary
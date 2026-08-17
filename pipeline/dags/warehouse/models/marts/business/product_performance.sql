with product_sales as (

    select

        product_key,

        count(distinct sales_order_id) as total_orders,
        sum(order_quantity) as total_quantity_sold,
        sum(gross_sales) as gross_sales,
        sum(discount_amount) as discount_amount,
        sum(net_sales) as net_sales,
        sum(total_cost) as total_cost,
        sum(profit) as total_profit

    from {{ ref('fact_order') }}

    group by product_key

),

product as (

    select

        product_key,
        product_id,
        product_name,
        product_subcategory_name,
        product_category_name

    from {{ ref('dim_product') }}

)

select

    p.product_key,
    p.product_id,
    p.product_name,
    p.product_subcategory_name,
    p.product_category_name,

    coalesce(s.total_orders, 0) as total_orders,
    coalesce(s.total_quantity_sold, 0) as total_quantity_sold,

    coalesce(s.gross_sales, 0) as gross_sales,
    coalesce(s.discount_amount, 0) as discount_amount,
    coalesce(s.net_sales, 0) as net_sales,

    coalesce(s.total_cost, 0) as total_cost,
    coalesce(s.total_profit, 0) as total_profit,

    safe_divide(
        s.total_profit,
        s.net_sales
    ) as profit_margin,

    safe_divide(
        s.net_sales,
        s.total_quantity_sold
    ) as average_selling_price

from product p

left join product_sales s
    on p.product_key = s.product_key
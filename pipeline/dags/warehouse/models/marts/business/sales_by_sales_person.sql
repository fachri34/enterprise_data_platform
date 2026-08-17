with fact as (

    select *
    from {{ ref('fact_order') }}

),

sales_person as (

    select *
    from {{ ref('dim_sales_person') }}

)

select

    sp.sales_person_key,
    sp.sales_person_id,

    count(distinct f.sales_order_id) as total_orders,

    sum(f.order_quantity) as total_quantity,

    sum(f.net_sales) as total_revenue,

    sum(f.total_cost) as total_cost,

    sum(f.profit) as total_profit,

    safe_divide(
        sum(f.profit),
        sum(f.net_sales)
    ) as profit_margin

from fact f

left join sales_person sp
    on f.sales_person_key = sp.sales_person_key

group by

    sp.sales_person_key,
    sp.sales_person_id
with fact as (

    select *
    from {{ ref('fact_order') }}

),

`date` as (

    select *
    from {{ ref('dim_date') }}

)

select

    d.year,
    d.month,
    d.month_name,
    d.year_month,

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

left join `date` d
    on f.order_date_key = d.date_key

group by

    d.year,
    d.month,
    d.month_name,
    d.year_month

order by

    d.year,
    d.month
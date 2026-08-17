with fact as (

    select *
    from {{ ref('fact_order') }}

),

territory as (

    select *
    from {{ ref('dim_sales_territory') }}

)

select

    t.sales_territory_key,
    t.sales_territory_id,
    t.sales_territory_name,
    t.sales_country_region_code,
    t.sales_territory_group,

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

left join territory t
    on f.sales_territory_key = t.sales_territory_key

group by

    t.sales_territory_key,
    t.sales_territory_id,
    t.sales_territory_name,
    t.sales_country_region_code,
    t.sales_territory_group 
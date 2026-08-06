
with orders as (

    select *
    from {{ ref('int_sales_orders') }}

),

items as (

    select *
    from {{ ref('int_sales_order_items') }}

),

dim_customer as (

    select *
    from {{ ref('dim_customer') }}

),

dim_product as (

    select *
    from {{ ref('dim_product') }}

),

dim_sales_person as (

    select *
    from {{ ref('dim_sales_person') }}

),

dim_territory as (

    select *
    from {{ ref('dim_sales_territory') }}

),

dim_store as (

    select *
    from {{ ref('dim_store') }}

),

dim_shipmethod as (

    select *
    from {{ ref('dim_shipmethod') }}

),

order_date as (

    select *
    from {{ ref('dim_date') }}

),

due_date as (

    select *
    from {{ ref('dim_date') }}

),

ship_date as (

    select *
    from {{ ref('dim_date') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'o.sales_order_id',
        'i.sales_order_detail_id'
    ]) }} as fact_order_key,

    dc.customer_key,

    dp.product_key,

    dsp.sales_person_key,

    dt.sales_territory_key,

    ds.store_key,

    dm.shipmethod_key,

    od.date_key as order_date_key,

    dd.date_key as due_date_key,

    sd.date_key as ship_date_key,

    o.sales_order_id,

    i.sales_order_detail_id,

    o.status as order_status,

    i.order_quantity,

    i.unit_price,

    i.unit_price_discount,

    i.standard_cost as unit_cost,

    i.gross_sales,

    i.discount_amount,

    i.net_sales,

    i.total_cost,

    i.profit,

    i.profit_margin,

    o.tax_amount,

    o.freight,

    o.total_due

from orders o

join items i
    on o.sales_order_id = i.sales_order_id

left join dim_customer dc
    on o.customer_id = dc.customer_id

left join dim_product dp
    on i.product_id = dp.product_id

left join dim_sales_person dsp
    on o.sales_person_id = dsp.sales_person_id

left join dim_territory dt
    on o.sales_territory_id = dt.sales_territory_id

left join dim_store ds
    on dc.store_id = ds.store_id

left join dim_shipmethod dm
    on o.shipmethod_id = dm.shipmethod_id

left join order_date od
    on cast(o.order_date as date) = od.date_actual

left join due_date dd
    on cast(o.due_date as date) = dd.date_actual

left join ship_date sd
    on cast(o.ship_date as date) = sd.date_actual
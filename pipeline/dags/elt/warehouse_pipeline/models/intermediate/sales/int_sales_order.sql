with orders as (

    select *

    from {{ ref('stg_sales_order_header') }}

),

customer as (

    select *

    from {{ ref('int_customer') }}

),

ship as (

    select *

    from {{ ref('stg_shipmethod') }}

),

territory as (

    select *

    from {{ ref('stg_sales_territory') }}

)

select

    o.sales_order_id,

    o.order_date,

    o.due_date,

    o.ship_date,

    o.status,

    o.customer_id,

    c.customer_name,

    c.store_name,

    o.sales_person_id,

    o.shipmethod_id,

    ship.shipmethod_name,

    o.sales_territory_id,

    territory.sales_territory_name,

    territory.sales_territory_group,

    o.subtotal,

    o.tax_amount,

    o.freight,

    o.total_due

from orders o

left join customer c

on o.customer_id=c.customer_id

left join ship

on o.shipmethod_id=ship.shipmethod_id

left join territory

on o.sales_territory_id=territory.sales_territory_id
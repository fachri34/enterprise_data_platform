with inventory as (

    select *

    from {{ ref('int_product_inventory') }}

),

product as (

    select *

    from {{ ref('int_product_master') }}

)

select

    i.product_id,

    i.location_id,

    p.product_name,

    p.product_category_name,

    p.product_subcategory_name,

    i.location_name,

    i.quantity,

    p.standard_cost,

    p.list_price,

    i.quantity*p.standard_cost as inventory_cost,

    i.quantity*p.list_price as inventory_retail_value

from inventory i

left join product p

on i.product_id=p.product_id
with inventory as (

    select *
    from {{ ref('fact_inventory') }}

),

product as (

    select *
    from {{ ref('dim_product') }}

),

location as (

    select *
    from {{ ref('dim_location') }}

)


select

    p.product_key,
    p.product_id,
    p.product_name,
    p.product_category_name,
    p.product_subcategory_name,

    l.location_key,
    l.location_id,
    l.location_name,

    i.quantity as quantity_on_hand,
    i.inventory_cost,
    i.inventory_retail_value,

    safe_divide(
        i.inventory_retail_value,
        i.quantity
    ) as average_retail_value_per_unit

from inventory i

left join product p
    on i.product_key = p.product_key

left join location l
    on i.location_key = l.location_key
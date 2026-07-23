with product as (

    select *
    from {{ ref('stg_product') }}

),

subcategory as (

    select *
    from {{ ref('stg_product_subcategory') }}

),

category as (

    select *
    from {{ ref('stg_product_category') }}

),

model as (

    select *
    from {{ ref('stg_product_model') }}

)

select

    p.product_id,
    p.product_name,
    p.product_number,

    p.standard_cost,
    p.list_price,

    p.product_model_id,
    m.product_model_name,

    p.product_subcategory_id,
    s.product_subcategory_name,

    c.product_category_id,
    c.product_category_name,

    p.size_unit_measure_code,
    p.weight_unit_measure_code,

    p.sell_start_date,
    p.sell_end_date,
    p.discontinued_date

from product p

left join subcategory s

on p.product_subcategory_id=s.product_subcategory_id

left join category c

on s.product_category_id=c.product_category_id

left join model m

on p.product_model_id=m.product_model_id
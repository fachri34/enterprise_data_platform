with detail as (

    select *

    from {{ ref('stg_sales_order_detail') }}

),

product as (

    select *

    from {{ ref('int_product_master') }}

),

offer as (

    select *

    from {{ ref('stg_special_offer') }}

)

select
    d.sales_order_detail_id,
    d.sales_order_id,
    d.product_id,
    d.special_offer_id,

    -- Product Information
    p.product_name,
    p.product_category_name,
    p.product_subcategory_name,

    -- Promotion Information
    o.special_offer_description,

    -- Sales Metrics
    d.order_quantity,
    d.unit_price,
    d.unit_price_discount,

    -- Derived Metrics
    d.order_quantity * d.unit_price
        as gross_sales,

    d.order_quantity
        * d.unit_price
        * d.unit_price_discount
        as discount_amount,

    d.order_quantity
        * d.unit_price
        * (1 - d.unit_price_discount)
        as net_sales

from detail d

left join product p
    on d.product_id = p.product_id

left join offer o
    on d.special_offer_id = o.special_offer_id
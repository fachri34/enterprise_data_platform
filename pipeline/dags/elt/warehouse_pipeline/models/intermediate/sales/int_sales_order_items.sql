with detail as (

    select *

    from {{ ref('stg_sales_order_detail') }}

),

product as (

    select

        product_id,
        standard_cost

    from {{ ref('int_product_master') }}

),

special_offer as (

    select

        special_offer_id

    from {{ ref('stg_special_offer') }}

)

select

    d.sales_order_detail_id,

    d.sales_order_id,

    d.product_id,

    d.special_offer_id,

    d.order_quantity,

    d.unit_price,

    d.unit_price_discount,

    p.standard_cost,

    (d.order_quantity * d.unit_price)
        as gross_sales,

    (
        d.order_quantity
        * d.unit_price
        * d.unit_price_discount
    )
        as discount_amount,

    (
        d.order_quantity
        * d.unit_price
        * (1 - d.unit_price_discount)
    )
        as net_sales,

    (
        d.order_quantity
        * p.standard_cost
    )
        as total_cost,

    (
        (
            d.order_quantity
            * d.unit_price
            * (1 - d.unit_price_discount)
        )
        -
        (
            d.order_quantity
            * p.standard_cost
        )
    )
        as profit,

    safe_divide(

        (
            (
                d.order_quantity
                * d.unit_price
                * (1 - d.unit_price_discount)
            )
            -
            (
                d.order_quantity
                * p.standard_cost
            )
        ),

        nullif(

            (
                d.order_quantity
                * d.unit_price
                * (1 - d.unit_price_discount)
            ),

            0

        )

    ) as profit_margin

from detail d

left join product p
    on d.product_id = p.product_id

left join special_offer s
    on d.special_offer_id = s.special_offer_id
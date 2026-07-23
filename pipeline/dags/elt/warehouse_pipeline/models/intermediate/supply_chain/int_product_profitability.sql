with price as (

    select *

    from {{ ref('int_product_price') }}

),

cost as (

    select *

    from {{ ref('int_product_cost') }}

),

product as (

    select *

    from {{ ref('int_product_master') }}

)

select

    p.product_id,

    p.product_name,

    price.list_price,

    cost.standard_cost,

    price.list_price-cost.standard_cost as unit_profit,

    safe_divide(

    price.list_price-cost.standard_cost,

    price.list_price

    ) as profit_margin

from product p

left join price

on p.product_id=price.product_id

left join cost

on p.product_id=cost.product_id
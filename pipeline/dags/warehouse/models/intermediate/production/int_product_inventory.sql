with inventory as (

    select *

    from {{ ref('stg_product_inventory') }}

),

location as (

    select *

    from {{ ref('stg_location') }}

)

select

    i.product_id,

    i.location_id,

    l.location_name,

    i.shelf,

    i.bin,

    i.quantity,

    l.cost_rate,

    l.availability

from inventory i

left join location l

on i.location_id=l.location_id
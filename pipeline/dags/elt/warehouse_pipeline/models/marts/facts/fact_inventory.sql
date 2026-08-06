with inventory as (

    select *
    from {{ ref('int_inventory_balance') }}

),

dim_product as (

    select *
    from {{ ref('dim_product') }}

),

dim_location as (

    select *
    from {{ ref('dim_location') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'i.product_id',
        'i.location_id'
    ]) }} as inventory_fact_key,

    dp.product_key,

    dl.location_key,

    i.quantity,

    i.inventory_cost,

    i.inventory_retail_value

from inventory i

left join dim_product dp
    on i.product_id = dp.product_id

left join dim_location dl
    on i.location_id = dl.location_id
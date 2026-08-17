with product as (

    select *

    from {{ ref('int_product_master') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'product_id'
    ]) }} as product_key,

    product_id,

    product_name,

    product_category_name,

    product_subcategory_name,

    standard_cost,

    list_price

from product
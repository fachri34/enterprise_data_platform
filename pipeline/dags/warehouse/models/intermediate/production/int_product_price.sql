with price as (

    select *

    from {{ ref('stg_product_list_price_history') }}

),

ranked as (

    select *,

    row_number() over(

    partition by product_id

    order by start_date desc

)   rn

from price

)

select

    product_id,

    list_price,

    start_date,

    end_date

from ranked

where rn=1
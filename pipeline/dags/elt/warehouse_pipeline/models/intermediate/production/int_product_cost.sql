with cost as (

    select *

    from {{ ref('stg_product_cost_history') }}

),

ranked as (

    select

    *,

    row_number() over(

    partition by product_id

    order by start_date desc

)   rn

from cost

)


select

    product_id,

    standard_cost,

    start_date,

    end_date

from ranked

where rn=1
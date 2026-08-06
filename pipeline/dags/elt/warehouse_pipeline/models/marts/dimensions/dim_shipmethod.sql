with ship as (

    select *

    from {{ ref('stg_shipmethod') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'shipmethod_id'
    ]) }} as shipmethod_key,

    shipmethod_id,

    shipmethod_name,

    ship_base,

    ship_rate

from ship
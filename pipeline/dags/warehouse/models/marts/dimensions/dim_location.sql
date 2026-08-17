with location as (

    select *

    from {{ ref('stg_location') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'location_id'
    ]) }} as location_key,

    location_id,

    location_name,

    cost_rate,

    availability

from location
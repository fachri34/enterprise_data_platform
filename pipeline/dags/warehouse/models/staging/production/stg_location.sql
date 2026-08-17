select
    locationid as location_id,
    name as location_name,
    costrate as cost_rate,
    availability as availability,
    modifieddate as modified_date
from {{ source('raw_production', 'location') }}
select
    unitmeasurecode as unit_measure_code,
    name as unit_measure_name,
    modifieddate as modified_date
from {{ source('raw_production', 'unitmeasure') }}
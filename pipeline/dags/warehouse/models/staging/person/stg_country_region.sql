select
    countryregioncode as country_region_code,
    name as country_region_name,
    modifieddate as modified_date
from {{ source('raw_person', 'countryregion') }}
where countryregioncode is not null
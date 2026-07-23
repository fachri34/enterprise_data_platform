select
    shipmethodid as shipmethod_id,
    name as shipmethod_name,
    shipbase as ship_base,
    shiprate as ship_rate,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_purchasing', 'shipmethod') }}
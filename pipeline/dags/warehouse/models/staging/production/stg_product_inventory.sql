select
    productid as product_id,
    locationid as location_id,
    shelf as shelf,
    bin as bin,
    quantity as quantity,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_production', 'productinventory') }}
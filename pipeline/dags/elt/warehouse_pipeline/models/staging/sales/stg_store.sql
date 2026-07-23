select
    businessentityid as store_id,
    name as store_name,
    salespersonid as sales_person_id,
    demographics as demographics,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_sales', 'store') }}
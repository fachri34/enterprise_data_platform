select
    productmodelid as product_model_id,
    name as product_model_name,
    catalogdescription as catalog_description,
    instructions as instructions,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_production', 'productmodel') }}
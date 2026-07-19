select
    productcategoryid as product_category_id,
    name as product_category_name,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_production', 'productcategory') }}
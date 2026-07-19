select
    productsubcategoryid as product_subcategory_id,
    productcategoryid as product_category_id,
    name as product_subcategory_name,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_production', 'productsubcategory') }}
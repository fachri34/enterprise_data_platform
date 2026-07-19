select
    specialofferid as special_offer_id,
    productid as product_id,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_sales', 'specialofferproduct') }}
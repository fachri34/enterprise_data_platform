select
    productid as product_id,
    startdate as start_date,
    enddate as end_date,
    listprice as list_price,
    modifieddate as modified_date
from {{ source('raw_production', 'productlistpricehistory') }}
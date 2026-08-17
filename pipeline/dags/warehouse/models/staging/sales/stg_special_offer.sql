select
    specialofferid as special_offer_id,
    description as special_offer_description,
    discountpct as discount_pct,
    type as special_offer_type,
    category as special_offer_category,
    startdate as start_date,
    enddate as end_date,
    minqty as min_qty,
    maxqty as max_qty,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_sales', 'specialoffer') }}
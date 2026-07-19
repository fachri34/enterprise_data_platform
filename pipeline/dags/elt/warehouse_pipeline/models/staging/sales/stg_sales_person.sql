select
    businessentityid as sales_person_id,
    territoryid as territory_id,
    salesquota as sales_quota,
    bonus as bonus,
    commissionpct as commission_pct,
    salesytd as sales_ytd,
    saleslastyear as sales_last_year,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_sales', 'salesperson') }}
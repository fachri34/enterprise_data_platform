select
    territoryid as sales_territory_id,
    name as sales_territory_name,
    countryregioncode as sales_country_region_code,
    `group` as sales_territory_group,
    salesytd as sales_territory_sales_ytd,
    saleslastyear as sales_territory_sales_last_year,
    costytd as sales_territory_cost_ytd,
    costlastyear as sales_territory_cost_last_year,
    rowguid as sales_territory_row_guid,
    modifieddate as sales_territory_modified_date
from {{ source('raw_sales', 'salesterritory') }}
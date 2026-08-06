with sales_territory as (
    select
        *
    from {{ ref('stg_sales_territory') }}
)


select
    {{ dbt_utils.generate_surrogate_key([
        'sales_territory_id'
    ]) }} as sales_territory_key,
    sales_territory_id,
    sales_territory_name,
    sales_country_region_code,
    sales_territory_group
from sales_territory
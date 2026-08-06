with salesperson as (

    select *

    from {{ ref('stg_sales_person') }}

),

territory as (

    select *

    from {{ ref('dim_sales_territory') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'sales_person_id'
    ]) }} as sales_person_key,

    s.sales_person_id,

    t.sales_territory_key,

    s.sales_quota,

    s.bonus,

    s.commission_pct,

    s.sales_ytd,

    s.sales_last_year

from salesperson s

left join territory t

on s.sales_territory_id = t.sales_territory_id
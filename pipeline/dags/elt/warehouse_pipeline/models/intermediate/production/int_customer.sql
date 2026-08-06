with customer as (

    select *

    from {{ ref('stg_customers') }}

),

person as (

    select *

    from {{ ref('stg_person') }}

),

store as (

    select *

    from {{ ref('stg_store') }}

),

territory as (

    select *

    from {{ ref('stg_sales_territory') }}

)

select

    c.customer_id,

    c.person_id,

    c.sales_territory_id,

    concat(

    p.first_name, ' ',

    coalesce(p.middle_name,''),

    ' ', p.last_name

    ) as customer_name,

    s.store_id,

    s.store_name,

    t.sales_territory_name,

    t.sales_country_region_code,

    t.sales_territory_group

from customer c

left join person p

on c.person_id=p.person_id

left join store s

on c.store_id=s.store_id

left join territory t

on c.sales_territory_id=t.sales_territory_id
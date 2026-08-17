with bridge as (

    select *

    from {{ ref('stg_sales_order_header_sales_reason') }}

),

reason as (

    select *

    from {{ ref('stg_sales_reason') }}

)

select

    b.sales_order_id,

    b.sales_reason_id,

    r.sales_reason_name,

    r.sales_reason_type

from bridge b

left join reason r

on b.sales_reason_id=r.sales_reason_id
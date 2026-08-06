with store as (

    select *

    from {{ ref('stg_store') }}

),

salesperson as (

    select *

    from {{ ref('dim_sales_person') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'store_id'
    ]) }} as store_key,

    st.store_id,

    st.store_name,

    sp.sales_person_key,

    st.demographics,

from store st

left join salesperson sp

on st.sales_person_id = sp.sales_person_id
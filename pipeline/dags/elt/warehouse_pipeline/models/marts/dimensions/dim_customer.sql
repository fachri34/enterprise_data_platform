with customer as (
    select
        *
    from {{ ref('stg_customers') }}
)

select
    {{ dbt_utils.generate_surrogate_key([
        'customer_id'
    ]) }} as customer_key,
    *
from customer
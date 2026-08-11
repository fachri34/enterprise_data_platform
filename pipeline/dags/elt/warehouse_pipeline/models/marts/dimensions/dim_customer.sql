with customer as (
    select
        *
    from {{ ref('int_customer') }}
)

select
    {{ dbt_utils.generate_surrogate_key([
        'customer_id'
    ]) }} as customer_key,
    *
from customer
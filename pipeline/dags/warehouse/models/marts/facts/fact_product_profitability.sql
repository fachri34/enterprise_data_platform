with profitability as (

    select *
    from {{ ref('int_product_profitability') }}

),

dim_product as (

    select *
    from {{ ref('dim_product') }}

)

select

    {{ dbt_utils.generate_surrogate_key([
        'p.product_id'
    ]) }} as profitability_fact_key,

    dp.product_key,

    p.list_price,

    p.standard_cost,

    p.unit_profit,

    p.profit_margin

from profitability p

left join dim_product dp
    on p.product_id = dp.product_id
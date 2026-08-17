with customer as (

    select *
    from {{ ref('customer_summary') }}

),

customer_metrics as (

    select

        customer_key,
        customer_id,
        customer_name,

        total_orders,
        total_sales,
        total_profit,
        total_items,

        first_order_date_key,
        last_order_date_key,

        profit_margin,
        average_order_value,

        date_diff(
            parse_date(
                '%Y%m%d',
                cast(last_order_date_key as string)
            ),
            parse_date(
                '%Y%m%d',
                cast(first_order_date_key as string)
            ),
            day
        ) as customer_lifetime_days

    from customer

    where first_order_date_key is not null
      and last_order_date_key is not null

)

select

    customer_key,
    customer_id,
    customer_name,
    total_orders,
    total_sales,
    total_profit,
    total_items,

    average_order_value,
    profit_margin,

    first_order_date_key,
    last_order_date_key,

    customer_lifetime_days,

    case
        when customer_lifetime_days > 0
        then safe_divide(
            total_sales,
            customer_lifetime_days
        ) * 365

        else total_sales
    end as estimated_annual_customer_value,

    case

        when total_profit >= 100000
            then 'High Value'

        when total_profit >= 25000
            then 'Medium Value'

        else 'Low Value'

    end as customer_value_segment

from customer_metrics
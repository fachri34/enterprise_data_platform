with inventory as (

    select *
    from {{ ref('inventory_summary') }}

),

product_sales as (

    select *
    from {{ ref('product_performance') }}

),

product_metrics as (

    select

        i.product_key,
        i.product_id,
        i.product_name,

        i.product_category_name,
        i.product_subcategory_name,

        i.location_key,
        i.location_id,
        i.location_name,

        i.quantity_on_hand,
        i.inventory_cost,
        i.inventory_retail_value,
        i.average_retail_value_per_unit,

        coalesce(
            p.total_orders,
            0
        ) as total_orders,

        coalesce(
            p.total_quantity_sold,
            0
        ) as total_quantity_sold,

        coalesce(
            p.net_sales,
            0
        ) as net_sales,

        coalesce(
            p.total_profit,
            0
        ) as total_profit,

        coalesce(
            p.average_selling_price,
            0
        ) as average_selling_price

    from inventory i

    left join product_sales p
        on i.product_key = p.product_key

)

select

    product_key,
    product_id,
    product_name,
    product_category_name,
    product_subcategory_name,
    location_key,
    location_id,
    location_name,
    quantity_on_hand,
    total_orders,
    total_quantity_sold,
    net_sales,
    total_profit,

    inventory_cost,
    inventory_retail_value,

    average_retail_value_per_unit,
    average_selling_price,

    case

        when quantity_on_hand = 0
            then 'Critical'

        when quantity_on_hand <= 10
             and total_quantity_sold > 0
            then 'High'

        when quantity_on_hand <= 25
             and total_quantity_sold > 0
            then 'Medium'

        else 'Low'

    end as reorder_priority,

    case

        when quantity_on_hand = 0
            then true

        when quantity_on_hand <= 10
             and total_quantity_sold > 0
            then true

        else false

    end as reorder_required

from product_metrics
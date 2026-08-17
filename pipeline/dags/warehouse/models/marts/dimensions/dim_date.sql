with date_spine as (

    {{
        dbt_utils.date_spine(
            datepart="day",
            start_date="cast('2010-01-01' as date)",
            end_date="cast('2035-12-31' as date)"
        )
    }}

),

calendar as (

    select

        cast(date_day as date) as date_actual

    from date_spine

)

select

    cast(format_date('%Y%m%d', date_actual) as int64) as date_key,

    date_actual,

    extract(year from date_actual) as year,

    extract(isoyear from date_actual) as iso_year,

    extract(quarter from date_actual) as quarter,

    concat(
        'Q',
        cast(extract(quarter from date_actual) as string)
    ) as quarter_name,

    date_trunc(date_actual, quarter) as quarter_start_date,

    last_day(date_actual, quarter) as quarter_end_date,

    extract(month from date_actual) as month,

    format_date('%B', date_actual) as month_name,

    format_date('%b', date_actual) as month_short_name,

    format_date('%Y-%m', date_actual) as year_month,

    date_trunc(date_actual, month) as month_start_date,

    last_day(date_actual) as month_end_date,

    extract(day from last_day(date_actual)) as days_in_month,

    extract(week from date_actual) as week_of_year,

    extract(isoweek from date_actual) as iso_week,

    cast(ceil(extract(day from date_actual) / 7.0) as int64)
        as week_of_month,

    extract(day from date_actual) as day_of_month,

    extract(dayofyear from date_actual) as day_of_year,

    extract(dayofweek from date_actual) as day_of_week,

    format_date('%A', date_actual) as day_name,

    format_date('%a', date_actual) as day_short_name,

    case
        when extract(dayofweek from date_actual) in (1,7)
        then true
        else false
    end as is_weekend,

    case
        when extract(dayofweek from date_actual) between 2 and 6
        then true
        else false
    end as is_weekday,

    case
        when date_actual = date_trunc(date_actual, month)
        then true
        else false
    end as is_month_start,

    case
        when date_actual = last_day(date_actual)
        then true
        else false
    end as is_month_end,

    case
        when date_actual = date_trunc(date_actual, quarter)
        then true
        else false
    end as is_quarter_start,

    case
        when date_actual = last_day(date_actual, quarter)
        then true
        else false
    end as is_quarter_end,

    date_trunc(date_actual, year) as year_start_date,

    last_day(date_actual, year) as year_end_date,

    case
        when date_actual = date_trunc(date_actual, year)
        then true
        else false
    end as is_year_start,

    case
        when date_actual = last_day(date_actual, year)
        then true
        else false
    end as is_year_end

from calendar
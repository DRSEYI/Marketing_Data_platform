{{ config(materialized='table') }}

with date_bounds as (

    select
        min(reporting_date) as first_date,
        max(reporting_date) as last_date
    from {{ ref('int_ads_performance_unified') }}

),

calendar as (

    select
        explode(
            sequence(first_date, last_date, interval 1 day)
        ) as calendar_date
    from date_bounds
    where first_date is not null
      and last_date is not null

)

select
    cast(date_format(calendar_date, 'yyyyMMdd') as int) as date_key,
    calendar_date,
    year(calendar_date) as calendar_year,
    quarter(calendar_date) as calendar_quarter,
    month(calendar_date) as month_number,
    date_format(calendar_date, 'MMMM') as month_name,
    dayofmonth(calendar_date) as day_of_month

from calendar
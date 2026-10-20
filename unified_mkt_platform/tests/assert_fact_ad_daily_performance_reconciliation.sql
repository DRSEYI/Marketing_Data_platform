--This checks that joining to dimensions has preserved row counts, spend, 
--impressions, clicks, and metric completeness.

--(Why group by currency and date? We compare corresponding reporting slices without mixing currencies.
-- The null-safe joins also correctly match Facebook records whose country is unavailable.)

with expected as (

    select
        platform as platform_code,
        reporting_date,
        currency_code,
        country_code,

        count(*) as row_count,
        sum(spend) as spend,
        sum(impressions) as impressions,
        sum(clicks) as clicks,

        count(spend) as known_spend,
        count(impressions) as known_impressions,
        count(clicks) as known_clicks

    from {{ ref('int_ads_performance_unified') }}

    group by
        platform,
        reporting_date,
        currency_code,
        country_code

),

actual as (

    select
        p.platform_code,
        d.calendar_date as reporting_date,
        f.currency_code,
        f.country_code,

        count(*) as row_count,
        sum(f.spend) as spend,
        sum(f.impressions) as impressions,
        sum(f.clicks) as clicks,

        count(f.spend) as known_spend,
        count(f.impressions) as known_impressions,
        count(f.clicks) as known_clicks

    from {{ ref('fact_ad_daily_performance') }} as f

    left join {{ ref('dim_platform') }} as p
        on f.platform_key = p.platform_key

    left join {{ ref('dim_date') }} as d
        on f.date_key = d.date_key

    group by
        p.platform_code,
        d.calendar_date,
        f.currency_code,
        f.country_code

)

select
    coalesce(e.platform_code, a.platform_code) as platform_code,
    coalesce(e.reporting_date, a.reporting_date) as reporting_date,
    coalesce(e.currency_code, a.currency_code) as currency_code,
    coalesce(e.country_code, a.country_code) as country_code,

    e.row_count as expected_rows,
    a.row_count as actual_rows,
    e.spend as expected_spend,
    a.spend as actual_spend,
    e.impressions as expected_impressions,
    a.impressions as actual_impressions,
    e.clicks as expected_clicks,
    a.clicks as actual_clicks,

    e.known_spend as expected_known_spend,
    a.known_spend as actual_known_spend,
    e.known_impressions as expected_known_impressions,
    a.known_impressions as actual_known_impressions,
    e.known_clicks as expected_known_clicks,
    a.known_clicks as actual_known_clicks

from expected as e

full outer join actual as a
    on e.platform_code <=> a.platform_code
    and e.reporting_date <=> a.reporting_date
    and e.currency_code <=> a.currency_code
    and e.country_code <=> a.country_code

where
    not (e.row_count <=> a.row_count)
    or not (e.spend <=> a.spend)
    or not (e.impressions <=> a.impressions)
    or not (e.clicks <=> a.clicks)
    or not (e.known_spend <=> a.known_spend)
    or not (e.known_impressions <=> a.known_impressions)
    or not (e.known_clicks <=> a.known_clicks)
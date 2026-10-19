with expected as (

    select
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
    from {{ ref('stg_snapchat_ads_stats') }}
    group by reporting_date, currency_code, country_code

),

actual as (

    select
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
    from {{ ref('int_snapchat_ads_performance') }}
    group by reporting_date, currency_code, country_code

)

select
    coalesce(e.reporting_date, a.reporting_date) as reporting_date,
    coalesce(e.currency_code, a.currency_code) as currency_code,
    coalesce(e.country_code, a.country_code) as country_code,
    e.spend as expected_spend,
    a.spend as actual_spend,
    e.impressions as expected_impressions,
    a.impressions as actual_impressions,
    e.clicks as expected_clicks,
    a.clicks as actual_clicks

from expected as e

full outer join actual as a
    on e.reporting_date <=> a.reporting_date
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
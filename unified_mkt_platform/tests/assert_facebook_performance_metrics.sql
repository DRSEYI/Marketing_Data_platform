--check that the Facebook joins preserve metric values and their missing values.

with expected as (

    select
        account_id,
        reporting_date,
        count(*) as row_count,
        sum(spend) as spend,
        sum(impressions) as impressions,
        sum(clicks) as clicks,
        count(spend) as known_spend,
        count(impressions) as known_impressions,
        count(clicks) as known_clicks
    from {{ ref('stg_facebook_ads_stats') }}
    group by account_id, reporting_date

),

actual as (

    select
        account_id,
        reporting_date,
        count(*) as row_count,
        sum(spend) as spend,
        sum(impressions) as impressions,
        sum(clicks) as clicks,
        count(spend) as known_spend,
        count(impressions) as known_impressions,
        count(clicks) as known_clicks
    from {{ ref('int_facebook_ads_performance') }}
    group by account_id, reporting_date

)

select
    coalesce(e.account_id, a.account_id) as account_id,
    coalesce(e.reporting_date, a.reporting_date) as reporting_date,
    e.spend as expected_spend,
    a.spend as actual_spend,
    e.impressions as expected_impressions,
    a.impressions as actual_impressions,
    e.clicks as expected_clicks,
    a.clicks as actual_clicks

from expected as e

full outer join actual as a
    on e.account_id = a.account_id
    and e.reporting_date = a.reporting_date

where
    not (e.row_count <=> a.row_count)
    or not (e.spend <=> a.spend)
    or not (e.impressions <=> a.impressions)
    or not (e.clicks <=> a.clicks)
    or not (e.known_spend <=> a.known_spend)
    or not (e.known_impressions <=> a.known_impressions)
    or not (e.known_clicks <=> a.known_clicks)
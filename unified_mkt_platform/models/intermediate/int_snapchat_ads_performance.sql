
---Note: As against stg_snapchat_ad_group model we use int_snapchat_ad_groups_current, which contains one record per ad group, 
----to prevent historical versions from multiplying performance rows.

{{ config(materialized='view') }}

with stats as (

    select *
    from {{ ref('stg_snapchat_ads_stats') }}

),

ads as (

    select *
    from {{ ref('stg_snapchat_ads') }}

),

ad_groups as (

    select *
    from {{ ref('int_snapchat_ad_groups_current') }}  

),

campaigns as (

    select *
    from {{ ref('stg_snapchat_campaigns') }}

)

select
    'snapchat' as platform,
    stats.reporting_date,

    campaigns.account_id,
    stats.currency_code,
    stats.country_code,

    stats.ad_id,
    ads.ad_name,

    ads.ad_group_id,
    ad_groups.ad_group_name,

    ad_groups.campaign_id,
    campaigns.campaign_name,

    stats.spend,
    stats.impressions,
    stats.clicks,

    ads.ad_id is null as is_ad_missing,
    ad_groups.ad_group_id is null as is_ad_group_missing,
    campaigns.campaign_id is null as is_campaign_missing,

    stats._source_file,
    stats._ingested_at

from stats

left join ads
    on stats.ad_id = ads.ad_id

left join ad_groups
    on ads.ad_group_id = ad_groups.ad_group_id

left join campaigns
    on ad_groups.campaign_id = campaigns.campaign_id
--This model joins the statistics to ads, campaigns, ad groups, and accounts—giving
--each performance row business context and a currency.
{{ config(materialized='view') }}

with stats as (

    select *
    from {{ ref('stg_facebook_ads_stats') }}

),

ads as (

    select *
    from {{ ref('stg_facebook_ads') }}

),

campaigns as (

    select *
    from {{ ref('stg_facebook_campaigns') }}

),

ad_groups as (

    select *
    from {{ ref('stg_facebook_ad_groups') }}

),

accounts as (

    select *
    from {{ ref('stg_facebook_accounts') }}

)

select
    'facebook' as platform,
    stats.reporting_date,
    stats.account_id,
    accounts.account_name,
    accounts.currency_code,

    stats.ad_id,
    ads.ad_name,
    ads.ad_status,

    ads.ad_group_id,
    ad_groups.ad_group_name,

    ads.campaign_id,
    campaigns.campaign_name,

    stats.spend,
    stats.impressions,
    stats.clicks,

    ads.ad_id is null as is_ad_missing,
    campaigns.campaign_id is null as is_campaign_missing,
    ad_groups.ad_group_id is null as is_ad_group_missing,
    accounts.account_id is null as is_account_missing,

    stats._source_file,
    stats._ingested_at

from stats

left join ads
    on stats.ad_id = ads.ad_id

left join campaigns
    on ads.campaign_id = campaigns.campaign_id

left join ad_groups
    on ads.ad_group_id = ad_groups.ad_group_id

left join accounts
    on stats.account_id = accounts.account_id
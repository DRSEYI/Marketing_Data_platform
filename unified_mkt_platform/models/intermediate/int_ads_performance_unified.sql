{{ config(materialized='view') }}

with facebook as (

    select
        platform,
        reporting_date,
        account_id,
        account_name,
        currency_code,

        cast(null as string) as country_code,
        false as is_country_available,

        ad_id,
        ad_name,
        ad_status,
        ad_group_id,
        ad_group_name,
        campaign_id,
        campaign_name,

        spend,
        impressions,
        clicks,

        is_ad_missing,
        is_ad_group_missing,
        is_campaign_missing,
        is_account_missing,

        _source_file,
        _ingested_at

    from {{ ref('int_facebook_ads_performance') }}

),

snapchat as (

    select
        platform,
        reporting_date,
        account_id,
        cast(null as string) as account_name,
        currency_code,

        country_code,
        true as is_country_available,

        ad_id,
        ad_name,
        cast(null as string) as ad_status,
        ad_group_id,
        ad_group_name,
        campaign_id,
        campaign_name,

        spend,
        impressions,
        clicks,

        is_ad_missing,
        is_ad_group_missing,
        is_campaign_missing,
        account_id is null as is_account_missing,

        _source_file,
        _ingested_at

    from {{ ref('int_snapchat_ads_performance') }}

)

select * from facebook

union all

select * from snapchat
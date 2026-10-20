

{{ config(materialized='view') }}

select
    f.ad_performance_key,

    d.calendar_date as reporting_date,
    d.calendar_year,
    d.calendar_quarter,
    d.month_number,
    d.month_name,

    p.platform_code,
    p.platform_name,

    account.account_id,
    account.account_name,

    campaign.campaign_id,
    campaign.campaign_name,

    ad_group.ad_group_id,
    ad_group.ad_group_name,

    ad.ad_id,
    ad.ad_name,
    ad.ad_status,

    f.currency_code,
    f.country_code,
    f.is_country_available,

    f.spend,
    f.impressions,
    f.clicks,

    f.is_impressions_missing,
    f.is_clicks_missing,

    f._source_file,
    f._ingested_at

from {{ ref('fact_ad_daily_performance') }} as f

left join {{ ref('dim_date') }} as d
    on f.date_key = d.date_key

left join {{ ref('dim_platform') }} as p
    on f.platform_key = p.platform_key

left join {{ ref('dim_account') }} as account
    on f.account_key = account.account_key

left join {{ ref('dim_campaign') }} as campaign
    on f.campaign_key = campaign.campaign_key

left join {{ ref('dim_ad_group') }} as ad_group
    on f.ad_group_key = ad_group.ad_group_key

left join {{ ref('dim_ad') }} as ad
    on f.ad_key = ad.ad_key
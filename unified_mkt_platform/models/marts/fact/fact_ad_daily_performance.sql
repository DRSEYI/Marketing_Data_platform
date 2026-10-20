{{ config(
    materialized='incremental',
    file_format='delta',
    incremental_strategy='merge',
    unique_key='ad_performance_key',
    on_schema_change='fail'
) }}

with performance as (

    select *
    from {{ ref('int_ads_performance_unified') }}

)

select
    sha2(
        to_json(
            named_struct(
                'platform', p.platform,
                'account_id', p.account_id,
                'ad_id', p.ad_id,
                'reporting_date', p.reporting_date,
                'currency_code', p.currency_code,
                'country_code', p.country_code
            ),
            map('ignoreNullFields', 'false')
        ),
        256
    ) as ad_performance_key,

    d.date_key,
    platform.platform_key,
    account.account_key,
    campaign.campaign_key,
    ad_group.ad_group_key,
    ad.ad_key,

    p.currency_code,
    p.country_code,
    p.is_country_available,

    p.spend,
    p.impressions,
    p.clicks,

    p.impressions is null as is_impressions_missing,
    p.clicks is null as is_clicks_missing,

    p._source_file,
    p._ingested_at

from performance as p

left join {{ ref('dim_date') }} as d
    on p.reporting_date = d.calendar_date

left join {{ ref('dim_platform') }} as platform
    on p.platform = platform.platform_code

left join {{ ref('dim_account') }} as account
    on p.platform = account.platform_code
    and p.account_id = account.account_id

left join {{ ref('dim_campaign') }} as campaign
    on p.platform = campaign.platform_code
    and p.campaign_id = campaign.campaign_id

left join {{ ref('dim_ad_group') }} as ad_group
    on p.platform = ad_group.platform_code
    and p.ad_group_id = ad_group.ad_group_id

left join {{ ref('dim_ad') }} as ad
    on p.platform = ad.platform_code
    and p.ad_id = ad.ad_id
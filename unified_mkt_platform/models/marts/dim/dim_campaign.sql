{{ config(materialized='table') }}

with campaigns as (

    select
        'facebook' as platform_code,
        campaign_id,
        campaign_name
    from {{ ref('stg_facebook_campaigns') }}

    union all

    select
        'snapchat' as platform_code,
        campaign_id,
        campaign_name
    from {{ ref('stg_snapchat_campaigns') }}

)

select
    concat(platform_code, ':', campaign_id) as campaign_key,
    platform_code,
    campaign_id,
    campaign_name

from campaigns
-- Snapchat’s status is  NULL because Its supplied ads file has no status column. We preserve that 
--absence rather than inventing a value.


{{ config(materialized='table') }}

with ads as (

    select
        'facebook' as platform_code,
        ad_id,
        ad_name,
        ad_status
    from {{ ref('stg_facebook_ads') }}

    union all

    select
        'snapchat' as platform_code,
        ad_id,
        ad_name,
        cast(null as string) as ad_status
    from {{ ref('stg_snapchat_ads') }}

)

select
    concat(platform_code, ':', ad_id) as ad_key,
    platform_code,
    ad_id,
    ad_name,
    ad_status

from ads
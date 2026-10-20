{{ config(materialized='table') }}

with ad_groups as (

    select
        'facebook' as platform_code,
        ad_group_id,
        ad_group_name
    from {{ ref('stg_facebook_ad_groups') }}

    union all

    select
        'snapchat' as platform_code,
        ad_group_id,
        ad_group_name
    from {{ ref('int_snapchat_ad_groups_current') }}

)

select
    concat(platform_code, ':', ad_group_id) as ad_group_key,
    platform_code,
    ad_group_id,
    ad_group_name

from ad_groups
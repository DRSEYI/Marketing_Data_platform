--Use fixed keys: 1 for Facebook, 2 for Snapchat. These remain stable across rebuilds.
--This gives reporting tools a consistent platform name

{{ config(materialized='table') }}

select
    1 as platform_key,
    'facebook' as platform_code,
    'Facebook Ads' as platform_name

union all

select
    2 as platform_key,
    'snapchat' as platform_code,
    'Snapchat Ads' as platform_name
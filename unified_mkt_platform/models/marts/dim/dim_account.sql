{{ config(materialized='table') }}

with facebook_accounts as (

    select
        'facebook' as platform_code,
        account_id,
        account_name
    from {{ ref('stg_facebook_accounts') }}

),

snapchat_accounts as (

    select distinct
        'snapchat' as platform_code,
        account_id,
        cast(null as string) as account_name
    from {{ ref('stg_snapchat_campaigns') }}

),

accounts as (

    select * from facebook_accounts

    union all

    select * from snapchat_accounts

)

select
    concat(platform_code, ':', account_id) as account_key,
    platform_code,
    account_id,
    account_name

from accounts
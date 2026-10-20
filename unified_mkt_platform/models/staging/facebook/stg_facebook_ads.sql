{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('facebook', 'facebook_ads') }}

),

staged as (

    select
        trim(ad_id) as ad_id,
        trim(campaign_id) as campaign_id,
        trim(ad_group_id) as ad_group_id,
        trim(account_id) as account_id,
        trim(ad_name) as ad_name,
        upper(trim(ad_status)) as ad_status,

        cast(trim(ad_updated_at)as timestamp
             ) as ad_updated_at,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
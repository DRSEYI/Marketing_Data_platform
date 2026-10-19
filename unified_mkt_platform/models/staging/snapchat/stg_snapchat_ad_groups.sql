{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('snapchat', 'snapchat_ad_groups') }}

),

staged as (

    select
        _surrogate_key,
        trim(ad_group_id) as ad_group_id,
        trim(campaign_id) as campaign_id,
        trim(ad_group_name) as ad_group_name,

        cast(
            trim(ad_group_updated_at) as timestamp
            )  as ad_group_updated_at,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('snapchat', 'snapchat_ads') }}

),

staged as (

    select
        trim(ad_id) as ad_id,
        trim(ad_group_id) as ad_group_id,
        trim(ad_name) as ad_name,


        cast(trim(ad_detail_updated_at)as timestamp) as ad_updated_at,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
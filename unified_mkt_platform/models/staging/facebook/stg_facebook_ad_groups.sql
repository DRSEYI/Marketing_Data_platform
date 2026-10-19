{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('facebook', 'facebook_ad_groups') }}

),

staged as (

    select
        trim(ad_group_id) as ad_group_id,
        trim(ad_group_name) as ad_group_name,

        cast(ad_group_updated_at as Timestamp ) as ad_group_updated_at,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
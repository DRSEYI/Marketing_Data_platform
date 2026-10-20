{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('facebook', 'facebook_campaigns') }}

),

staged_campaign as (

    select
        trim(campaign_id) as campaign_id,
        trim(campaign_name) as campaign_name,

        cast(campaign_updated_at as timestamp)as campaign_updated_at,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged_campaign
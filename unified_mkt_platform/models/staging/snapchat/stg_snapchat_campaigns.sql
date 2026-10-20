{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('snapchat', 'snapchat_campaigns') }}

),

staged as (

    select
        trim(campaign_id) as campaign_id,
        trim(account_id) as account_id,
        trim(campaign_name) as campaign_name,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
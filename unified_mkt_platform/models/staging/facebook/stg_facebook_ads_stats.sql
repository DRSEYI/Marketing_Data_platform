
--Preserve IDs as strings, Converts spend to decimal,impression 
--and clicks to whole number  and cast ad_dates as date
---model is materialised as view 

{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('facebook', 'facebook_ads_stats') }}

),

staged as (

    select
        ad_id,
        account_id,

        cast(
            nullif(nullif(lower(trim(ad_spend)), 'null'), '')
            as decimal(18, 6)
        ) as spend,

        cast(
            nullif(nullif(lower(trim(ad_impressions)), 'null'), '')
            as bigint
        ) as impressions,

        cast(
            nullif(nullif(lower(trim(ad_clicks)), 'null'), '')
            as bigint
        ) as clicks,

        cast(ad_date as date) as reporting_date,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('snapchat', 'snapchat_ads_stats') }}

),

staged as (

    select
        ad_detail_id as ad_id,

        upper(trim(ad_currency_code)) as currency_code,
        upper(trim(ad_country)) as country_code,

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

        data_src,
        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
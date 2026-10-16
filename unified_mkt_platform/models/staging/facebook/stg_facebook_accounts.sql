{{ config(materialized='view') }}

with source_data as (

    select *
    from {{ source('facebook', 'facebook_accounts') }}

),

staged as (

    select
        trim(account_id) as account_id,
        trim(account_name) as account_name,
        upper(trim(ad_currency_code)) as currency_code,

        cast(
            nullif(nullif(lower(trim(account_created_at)), 'null'), '')
            as timestamp
        ) as account_created_at,

        cast(
            nullif(nullif(lower(trim(account_updated_at)), 'null'), '')
            as timestamp
        ) as account_updated_at,

        _source_file,
        _ingested_at

    from source_data

)

select *
from staged
--Selecting latest ad_group using the  ad_group_updated_at.This is for removal
-- of duplicate values from stg_snapchat_ad_groups 


{{ config(materialized='view') }}

select *
from {{ ref('stg_snapchat_ad_groups') }}

qualify row_number() over (
    partition by ad_group_id
    order by
        ad_group_updated_at desc nulls last,
        _surrogate_key desc
) = 1
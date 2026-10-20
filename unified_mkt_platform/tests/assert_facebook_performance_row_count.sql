with source_count as (

    select count(*) as row_count
    from {{ ref('stg_facebook_ads_stats') }}

),

result_count as (

    select count(*) as row_count
    from {{ ref('int_facebook_ads_performance') }}

)

select
    source_count.row_count as expected_rows,
    result_count.row_count as actual_rows
from source_count
cross join result_count
where source_count.row_count <> result_count.row_count
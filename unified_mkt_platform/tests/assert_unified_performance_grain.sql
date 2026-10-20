select
    platform,
    account_id,
    ad_id,
    reporting_date,
    currency_code,
    country_code,
    count(*) as row_count

from {{ ref('int_ads_performance_unified') }}

group by
    platform,
    account_id,
    ad_id,
    reporting_date,
    currency_code,
    country_code

having count(*) > 1
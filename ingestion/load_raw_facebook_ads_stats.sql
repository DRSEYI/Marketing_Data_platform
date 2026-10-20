CREATE TABLE IF NOT EXISTS marketing_prod.raw.facebook_ads_stats
USING DELTA
AS
SELECT
    ad_id,
    account_id,
    ad_spend,
    ad_impressions,
    ad_clicks,
    ad_date,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/facebook_ads/ads_stats.csv',
    format => 'csv',
    header => true,
    schema => 'ad_id STRING,
               account_id STRING,
               ad_spend STRING,
               ad_impressions STRING,
               ad_clicks STRING,
               ad_date STRING',
    mode => 'FAILFAST'
);
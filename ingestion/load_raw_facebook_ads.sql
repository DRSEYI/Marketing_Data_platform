CREATE TABLE IF NOT EXISTS marketing_prod.raw.facebook_ads
USING DELTA
AS
SELECT
    ad_id,
    campaign_id,
    ad_group_id,
    account_id,
    ad_name,
    ad_status,
    ad_updated_at,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/facebook_ads/new_ads_de_randomized.csv',
    format => 'csv',
    header => true,
    schema => 'ad_id STRING,
               campaign_id STRING,
               ad_group_id STRING,
               account_id STRING,
               ad_name STRING,
               ad_status STRING,
               ad_updated_at STRING',
    mode => 'FAILFAST'
);
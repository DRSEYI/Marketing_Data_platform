CREATE TABLE IF NOT EXISTS marketing_prod.raw.snapchat_ads
USING DELTA
AS
SELECT
    ad_id,
    ad_group_id,
    ad_name,
    ad_detail_updated_at,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/snapchat_ads/snapchat_ads_ad_history_new_ad_names.csv',
    format => 'csv',
    header => true,
    schema => 'ad_id STRING,
               ad_group_id STRING,
               ad_name STRING,
               ad_detail_updated_at STRING',
    mode => 'FAILFAST'
);
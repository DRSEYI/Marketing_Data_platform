CREATE TABLE IF NOT EXISTS marketing_prod.raw.snapchat_ad_groups
USING DELTA
AS
SELECT
    _surrogate_key,
    ad_group_id,
    campaign_id,
    ad_group_name,
    ad_group_updated_at,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/snapchat_ads/snapchat_ads_adgroup_history_new_ad_group_names.csv',
    format => 'csv',
    header => true,
    schema => '_surrogate_key STRING,
               ad_group_id STRING,
               campaign_id STRING,
               ad_group_name STRING,
               ad_group_updated_at STRING',
    mode => 'FAILFAST'
);
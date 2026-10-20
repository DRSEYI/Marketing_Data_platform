CREATE TABLE IF NOT EXISTS marketing_prod.raw.snapchat_campaigns
USING DELTA
AS
SELECT
    campaign_id,
    account_id,
    campaign_name,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/snapchat_ads/snapchat_ads_campaign_history_new_campaign_names.csv',
    format => 'csv',
    header => true,
    schema => 'campaign_id STRING,
               account_id STRING,
               campaign_name STRING',
    mode => 'FAILFAST'
);
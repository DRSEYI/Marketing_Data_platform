CREATE TABLE IF NOT EXISTS marketing_prod.raw.facebook_campaigns
USING DELTA
AS
SELECT
    campaign_id,
    campaign_name,
    campaign_updated_at,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/facebook_ads/new_campaign_de_randomized.csv',
    format => 'csv',
    header => true,
    schema => 'campaign_id STRING,
               campaign_name STRING,
               campaign_updated_at STRING',
    mode => 'FAILFAST'
);
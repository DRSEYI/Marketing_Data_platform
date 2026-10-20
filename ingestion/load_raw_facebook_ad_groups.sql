CREATE TABLE IF NOT EXISTS marketing_prod.raw.facebook_ad_groups
USING DELTA
AS
SELECT
    ad_group_id,
    ad_group_name,
    ad_group_updated_at,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/facebook_ads/new_adgroup_de_randomized.csv',
    format => 'csv',
    header => true,
    schema => 'ad_group_id STRING,
               ad_group_name STRING,
               ad_group_updated_at STRING',
    mode => 'FAILFAST'
);
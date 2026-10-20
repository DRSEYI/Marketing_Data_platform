CREATE TABLE IF NOT EXISTS marketing_prod.raw.snapchat_ads_stats
USING DELTA
AS
SELECT
    ad_detail_id,
    ad_currency_code,
    ad_country,
    ad_spend,
    ad_impressions,
    ad_clicks,
    ad_date,
    data_src,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/snapchat_ads/snapchat_ads_stats.csv',
    format => 'csv',
    header => true,
    schema => 'ad_detail_id STRING,
               ad_currency_code STRING,
               ad_country STRING,
               ad_spend STRING,
               ad_impressions STRING,
               ad_clicks STRING,
               ad_date STRING,
               data_src STRING',
    mode => 'FAILFAST'
);
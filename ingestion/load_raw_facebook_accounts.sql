CREATE TABLE IF NOT EXISTS marketing_prod.raw.facebook_accounts
USING DELTA
AS
SELECT
    account_id,
    account_name,
    ad_currency_code,
    account_created_at,
    account_updated_at,
    _metadata.file_path AS _source_file,
    current_timestamp() AS _ingested_at
FROM read_files(
    '/Volumes/marketing_prod/landing/facebook_ads/new_acccount_de_randomized.csv',
    format => 'csv',
    header => true,
    schema => 'account_id STRING,
               account_name STRING,
               ad_currency_code STRING,
               account_created_at STRING,
               account_updated_at STRING',
    mode => 'FAILFAST'
);
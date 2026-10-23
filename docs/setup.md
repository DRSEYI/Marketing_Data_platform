# Setup and ingestion

[Back to project overview](../README.md)

## Repository guide

| Path | Contents |
|---|---|
| `pyproject.toml`, `uv.lock` | Python dependency declarations and lockfile |
| `ingestion/` | Nine production raw-load SQL files and OAuth SQL runner |
| `unified_mkt_platform/dbt_project.yml` | dbt project and layer configuration |
| `unified_mkt_platform/models/staging/source.yml` | Facebook and Snapchat source definitions |
| `unified_mkt_platform/models/staging/` | Source-specific cleaning views |
| `unified_mkt_platform/models/intermediate/` | Enrichment, current-record selection and unification |
| `unified_mkt_platform/models/marts/dim/` | Six dimensions |
| `unified_mkt_platform/models/marts/fact/` | Incremental daily advertising fact |
| `unified_mkt_platform/models/marts/reporting/` | Business-facing reporting view |
| `unified_mkt_platform/tests/` | Singular reconciliation and grain tests |
| `unified_mkt_platform/macros/` | Schema-routing logic and project macros |
| `unified_mkt_platform/ci/` | Credential-free CI and production profile templates |
| `.github/workflows/dbt-ci.yml` | Pull-request validation |
| `.github/workflows/dbt-prod.yml` | Production deployment |


## Local setup and execution

The workflow uses Python 3.12.9 and uv 0.12.21. Install uv, obtain authorised Databricks access and clone the repository. Commands below run from the repository root unless stated otherwise.

```powershell
uv python install 3.12.9
uv sync --locked
```

Create an untracked `unified_mkt_platform/profiles.yml` with the local `dev` target. Its connection settings use `DATABRICKS_PAT_TOKEN`, `DEV_CATALOG`, `DEV_SCHEMA` and `DEV_HTTP_PATH`, plus the workspace hostname. Set these in the current shell using your approved local credential process. A `.env` file is not automatically loaded by these commands.

```powershell
cd unified_mkt_platform
uv run --locked dbt deps --target dev
uv run --locked dbt debug --target dev
uv run --locked dbt build --target dev --fail-fast
```

Never commit local profiles, tokens, OAuth secret values or `.env` files. Tracked example profiles contain environment-variable references only.

### Production raw ingestion

Upload the supplied CSV files to the appropriate volumes under `/Volumes/marketing_prod/landing/facebook_ads/` and `/Volumes/marketing_prod/landing/snapchat_ads/`.

The runner reads these environment variables:

- `PROD_DATABRICKS_HOST` — hostname without `https://`.
- `PROD_DATABRICKS_HTTP_PATH` — SQL warehouse HTTP path.
- `PROD_DATABRICKS_CLIENT_ID` — production Service Principal Application ID.
- `DBT_ENV_SECRET_PROD_DATABRICKS_CLIENT_SECRET` — OAuth secret value.

Example from the repository root:

```powershell
uv run python ingestion/run_production_sql.py ingestion/load_raw_facebook_ads_stats.sql facebook_ads_stats
```

Use the corresponding SQL file and allowlisted table name for the other eight raw tables. Each file contains one initial-creation statement. The runner prints its connected identity and the resulting table count.

**Important:** `CREATE TABLE IF NOT EXISTS ... AS SELECT` does nothing if the table already exists, even if it is empty. These scripts do not append new exports or refresh existing tables. Recurring ingestion needs a separate loading strategy before this pipeline can ingest a live feed.

### Production dbt commands

Use a local `prod` profile equivalent to `unified_mkt_platform/ci/profiles.prod.yml.example`, with the production variables set. From `unified_mkt_platform`:

```powershell
uv run --locked dbt debug --target prod
uv run --locked dbt build --target prod --vars '{"raw_catalog": "marketing_prod"}' --fail-fast
uv run --locked dbt docs generate --static --target prod --vars '{"raw_catalog": "marketing_prod"}'
```

Production source selection currently relies on passing the explicit variable. A missing variable falls back to development raw data; always use the production workflow or the complete command above.

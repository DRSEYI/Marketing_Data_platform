import os
import sys
from pathlib import Path

from databricks import sql
from databricks.sdk.core import Config, oauth_service_principal


def main():
    if len(sys.argv) != 3:
        raise SystemExit(
            "Usage: python ingestion/run_production_sql.py "
            "<sql-file> <raw-table-name>"
        )

    sql_file = Path(sys.argv[1])
    table_name = sys.argv[2]

    allowed_tables = {
        "facebook_accounts",
        "facebook_campaigns",
        "facebook_ad_groups",
        "facebook_ads",
        "facebook_ads_stats",
        "snapchat_campaigns",
        "snapchat_ad_groups",
        "snapchat_ads",
        "snapchat_ads_stats",
    }

    if table_name not in allowed_tables:
        raise SystemExit("Unexpected raw table name")

    statement = sql_file.read_text(encoding="utf-8-sig")

    hostname = os.environ["PROD_DATABRICKS_HOST"]
    config = Config(
        host=f"https://{hostname}",
        client_id=os.environ["PROD_DATABRICKS_CLIENT_ID"],
        client_secret=os.environ[
            "DBT_ENV_SECRET_PROD_DATABRICKS_CLIENT_SECRET"
        ],
    )

    def credentials_provider():
        return oauth_service_principal(config)

    with sql.connect(
        server_hostname=hostname,
        http_path=os.environ["PROD_DATABRICKS_HTTP_PATH"],
        credentials_provider=credentials_provider,
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT current_user()")
            print("Connected identity:", cursor.fetchone()[0])

            cursor.execute(statement)
            print("SQL completed:", sql_file.name)

            cursor.execute(
                f"SELECT COUNT(*) FROM marketing_prod.raw.{table_name}"
            )
            print(f"{table_name} rows:", cursor.fetchone()[0])


if __name__ == "__main__":
    main()
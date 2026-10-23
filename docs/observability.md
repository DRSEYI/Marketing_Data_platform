# Documentation and observability

[Back to project overview](../README.md)

## Documentation, lineage and observability

Model and column YAML files hold descriptions and tests. `dbt docs generate --static` produces `target/static_index.html`, with model-level lineage. Static production documentation was generated and opened successfully. This does not claim column-level lineage tooling.

Elementary's dbt package collects run and test metadata. Production monitoring objects live in `marketing_prod.elementary`; development monitoring was configured in `marketing_dev.staging`.

The local Elementary CLI needs its own top-level `elementary` profile with the appropriate `dev` or `prod` output. From the dbt directory:

```powershell
uv run edr report --profiles-dir . --profile-target prod --days-back 7
```

The Python Elementary CLI and dbt package are separately versioned: the observed CLI version is 0.22.0 and dbt package version is 0.26.1. Use the committed dependency locks to reproduce the project rather than independently upgrading during deployment.

Some singular tests referencing multiple models are not displayed in the Elementary HTML report, even when dbt executes them and their results are collected. Use dbt results and stored monitoring records to verify those tests. Source freshness, volume and anomaly monitors have not been configured; report generation alone does not establish those checks.

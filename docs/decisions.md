# Design decisions and limitations

[Back to project overview](../README.md)

## Key design decisions and trade-offs

| Decision | Reason | Trade-off |
|---|---|---|
| Preserve raw business fields as strings | Keep supplied values intact and apply cleaning consistently in dbt | Raw tables are not ready for business analysis |
| Separate landing, raw, staging, intermediate and marts | Give each layer a clear responsibility | More objects to manage than a single transformation query |
| Use a star schema with a reporting view | Support reusable dimensions and accessible SQL without repeating joins in every report | Dimension and fact relationships require maintenance and testing |
| Keep missing metrics as NULL | Distinguish unknown values from genuine zero activity | Reports must account for incomplete metric coverage |
| Use current-state dimensions | Keep the case-study model understandable and manageable | Historical facts display current descriptive attributes; attribute history is not reconstructed |
| Retain all raw Snapchat ad-group history and select current records downstream | Preserve evidence while preventing join multiplication | The selected current record does not provide an as-of-date historical join |
| Use an incremental Delta merge for the fact, reading all source rows | Apply corrections to older reporting dates without relying on an unverified change watermark | Target writes are incremental, but source scanning is not optimised |
| Run the full dbt project in CI | Validate relationships and reconciliation across the supplied dataset | Higher runtime and warehouse usage than slim CI |
| Separate environments by catalog and schema | Isolate outputs and permissions while keeping the case study manageable | A shared workspace or warehouse does not provide complete compute isolation |
| Load CSVs with initial-creation SQL | Make the supplied-data ingestion reproducible and reviewable | This is bootstrap ingestion, not an automated recurring source feed |


## Operational limitations and next improvements

- Replace bootstrap CSV ingestion with a recurring load process that handles new files, retries, schema changes and duplicate deliveries.
- Confirm source currency units, timezones and click definitions; introduce an explicit FX policy if cross-currency spend is needed.
- Establish freshness expectations appropriate to the real extraction schedule before configuring freshness alerts.
- Add a reliable change watermark or bounded reprocessing strategy when source volume makes full scanning expensive.
- Define deletion and key-change handling: the current fact merge does not remove rows that disappear from its source.
- Retain generated documentation and deployment evidence as access-controlled artifacts.
- Automate the incremental integration checks and CI schema cleanup.
- Formalise group-based consumer access and a recovery procedure for partial deployments.

These limitations do not change the demonstrated model grain or the successful supplied-data tests. They define the work needed to evolve this case-study implementation into a continuously operated production service.

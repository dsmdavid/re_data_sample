cd weather
dbt deps
dbt run-operation create_artifact_resources
dbt run --exclude package:re_data package:dbt_artifacts
dbt --no-write-json run-operation upload_dbt_artifacts_v2
dbt run --select package:re_data
dbt --no-write-json run-operation upload_dbt_artifacts_v2
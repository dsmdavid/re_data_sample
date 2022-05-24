cd weather
echo "--- deps start ---"
dbt deps
echo "--- deps end ---"
echo "\n\n\n\n\n"
echo "--- run-operation create-artifact start ---"
dbt run-operation create_artifact_resources
echo "--- run-operation create-artifact end ---"
echo "\n\n\n\n\n"
echo "\n\n\n\n\n"
echo "\n\n\n\n\n"
echo "--- run main start ---"
dbt run --exclude package:re_data package:dbt_artifacts
echo "--- run main end ---"
echo "\n\n\n\n\n"
echo "\n\n\n\n\n"
echo "\n\n\n\n\n"
echo "--- run upload artifacts start ---"
dbt --no-write-json run-operation upload_dbt_artifacts_v2
echo "\n\n\n\n\n"
echo "--- run re_data & artifacts ---"
dbt run --select package:re_data package:dbt_artifacts
echo "\n\n\n\n\n"
echo "--- run upload artifacts (II) start ---"
dbt --no-write-json run-operation upload_dbt_artifacts_v2
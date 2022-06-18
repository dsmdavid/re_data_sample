cd weather
echo "is it bash?"
echo $O
echo "--- deps start ---"
dbt deps
echo "--- deps end ---"
echo -ne "\n\n\n\n\n"
echo "--- run-operation create-artifact start ---"
dbt run-operation create_artifact_resources
echo "--- run-operation create-artifact end ---"
echo -ne "\n\n\n\n\n"
echo -ne "\n\n\n\n\n"
echo -ne "\n\n\n\n\n"
echo "--- run main start ---"
dbt run --exclude package:re_data package:dbt_artifacts
echo "--- run main end ---"
echo -ne "\n\n\n\n\n"
echo -ne "\n\n\n\n\n"
echo -ne "\n\n\n\n\n"
echo "--- run upload artifacts start ---"
dbt --no-write-json run-operation upload_dbt_artifacts_v2
echo -ne "\n\n\n\n\n"
echo "--- run re_data & artifacts ---"
dbt run --select package:re_data package:dbt_artifacts
echo -ne "\n\n\n\n\n"
echo "--- run upload artifacts (II) start ---"
echo "skipping: dbt --no-write-json run-operation upload_dbt_artifacts_v2" 

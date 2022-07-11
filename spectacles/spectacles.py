import time
import requests
import os
import sys
# Define Spectacles IDs and API key
org_id = os.getenv("SPECTACLES_ORG")
suite_id = os.getenv("SPECTACLES_SUITE_ID")
project_id = os.getenv("SPECTACLES_PROJECT_ID")
# Set the API key in header
api_key = os.getenv("SPECTACLES_API_KEY")
if not api_key:
    with open("./secrets/spectacles.key","r") as f:
        api_key = f.read()

if not api_key:
    raise Exception("No API key found for spectacles, aborting").
headers = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
# Define the schema of the dbt staging data
dvd_spectacles_db = os.getenv('pr_ci_db')
# Create a run
create_run_url = "https://app.spectacles.dev/api/v1/runs"
payload = {
    "org_id": org_id,
    "suite_id": suite_id,
    "project_id": project_id,
    # This tells Spectacles to update that user attribute for the run
    "user_attributes": {"dvd_spectacles_db": dvd_spectacles_db}, 
}
create_run_response = requests.post(url=create_run_url, headers=headers, json=payload)
create_run_response.raise_for_status()
run_id = create_run_response.json()["run_id"]
run_status = "queued"
run_url = (
    f"https://app.spectacles.dev/api/v1/org/{org_id}/proj/{project_id}/run/{run_id}"
)
while run_status not in ["cancelled", "error", "passed", "failed"]:
    # Naively wait for 5 seconds to check
    time.sleep(5)
    # Get the run's results
    run_response = requests.get(url=run_url, headers=headers)
    run_status = run_response.json()["status"]
print(run_response.json()["url"])
if run_status != "passed":
    sys.exit(100)
else:
    print("Run succeeded.")
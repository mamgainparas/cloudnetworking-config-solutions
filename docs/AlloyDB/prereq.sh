# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ -z "$GOOGLE_CLOUD_PROJECT" ]
then
   echo Project not set!
   echo What project do you want to deploy the solution to?
   read var_project_id
   gcloud config set project $var_project_id
   export GOOGLE_CLOUD_PROJECT=$var_project_id
fi

echo Running prerequisites on project $GOOGLE_CLOUD_PROJECT
BUCKET_NAME=gs://$GOOGLE_CLOUD_PROJECT-tf-state-1
if gsutil ls $BUCKET_NAME; then
    echo Terraform bucket already created!
else
    echo Creating Terraform state bucket...
    gsutil mb $BUCKET_NAME
fi

cd ../../execution

ls

echo Running Organisation stage
./run.sh -s organisation -t init-apply-auto-approve

echo Running Networking Stage
./run.sh -s networking -t init-apply-auto-approve

echo Running Alloydb Stage
./run.sh -s producer/alloydb -t init-apply-auto-approve

echo "Granting Cloud Build's Service Account IAM roles to deploy the resources..."
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT --format='value(projectNumber)')
MEMBER=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/editor
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/iam.securityAdmin
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/compute.networkAdmin
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member=$MEMBER --role=roles/secretmanager.secretAccessor

echo Script completed successfully!

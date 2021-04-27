#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

gcloud functions deploy ${FUNCTION_NAME} \
  ${JOB_PATH}${FUNCTION_JOB}  \
  --region=${REGION} \
  --runtime=python38 \
  --trigger-resource=${DATALAKE_PATH} \
  --trigger-event=google.storage.object.finalize
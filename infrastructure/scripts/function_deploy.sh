#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

zip -urj ../../functions/load_data_into_bigquery.zip ../../functions/load_data_into_bigquery \
&& \
gcloud functions deploy ${FUNCTION_NAME} \
  ${FUNCTION_PATH}${FUNCTION_JOB}  \
  --region=${REGION} \
  --runtime=python38 \
  --trigger-resource=${DATALAKE_PATH} \
  --trigger-event=google.storage.object.finalize
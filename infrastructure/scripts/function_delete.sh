#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

gcloud functions ${FUNCTION_NAME} \
  --region=${REGION}
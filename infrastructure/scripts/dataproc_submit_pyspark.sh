#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

gcloud dataproc jobs submit pyspark \
  ${JOB_PATH}${PYSPARK_JOB} \
  --cluster=${CLUSTER_NAME} \
  --region=${REGION}
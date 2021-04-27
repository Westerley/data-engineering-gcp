#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

gsutil mb ${DATALAKE_PATH} \
  -p ${PROJECT_ID} \
  -c ${STORAGE_CLASS} \
  -l ${LOCATION}

gsutil mb ${DATALAKE_PATH}/raw_data
gsutil mb ${DATALAKE_PATH}/processing_zone
gsutil mb ${DATALAKE_PATH}/consumer_zone
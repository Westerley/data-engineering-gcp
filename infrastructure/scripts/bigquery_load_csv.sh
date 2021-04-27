#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

bq mk -t \
  --schema ${TABLE_SCHEMA} \
  ${TABLE} \
&& \
bq load \
  --location=${LOCATION} \
  --source_format=CSV \
  ${TABLE} \
  ${DATALAKE_PATH}${TITANIC_JSON}
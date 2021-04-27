#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

## JSON NON PARTITIONED

# Create schema and load data
bq mk -t \
  --schema ${TABLE_SCHEMA} \
  ${TABLE} \
&& \
bq load --source_format=NEWLINE_DELIMITED_JSON \
  ${TABLE} \
  ${DATALAKE_PATH}${TITANIC_JSON}

# There is chance to load the data with autodetect schema. Check the code below
# note: in some cases it didn't work

#bq load --source_format=NEWLINE_DELIMITED_JSON --autodetect \
#  ${TABLE} \
#  ${DATALAKE_PATH}${TITANIC_JSON}


# JSON PARTITIONED

#bq mk -t \
#  --schema ${TABLE_SCHEMA} \
#  --time_partitioning_field ${FIELD_PARTITIONING} \
#  ${TABLE}

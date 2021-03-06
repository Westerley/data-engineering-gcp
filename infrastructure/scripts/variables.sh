#!/bin/bash

# Configuration
: "${ACCOUNT_NAME:="airflow@dataengineer-310515.iam.gserviceaccount.com"}"
: "${PROJECT_ID:="dataengineer-310515"}"

# Dataproc
: "${CLUSTER_NAME:="cluster-lab"}"
: "${REGION:="us-central1"}"
: "${ZONE:="us-central1-b"}"
: "${MASTER_MACHINE_TYPE:="n1-standard-2"}"
: "${MASTER_BOOT_DISK:=30}"
: "${NUM_WORKERS:=2}"
: "${WORKER_MACHINE_TYPE:="n1-standard-2"}"
: "${WORKER_BOOT_DISK:=30}"

# Bigquery
: "${TABLE_SCHEMA:="/usr/local/airflow/schemas/passenger_schema.json"}"
: "${TABLE:="datawarehouse.tb_passengers"}"
: "${FIELD_PARTITIONING:=""}"
: "${TITANIC_JSON:="titanic.json"}"
: "${TITANIC_CSV:="titanic.csv"}"
: "${LOCATION:=${REGION}}"

# Pyspark
: "${JOB_PATH:="/usr/local/airflow/jobs/"}"
: "${PYSPARK_JOB:="titanic_job.py"}"

# Storage
: "${DATALAKE_PATH:="gs://datalake-lab/"}"
: "${STORAGE_CLASS:="STANDARD"}"

# Functions
: "${FUNCTION_PATH:="/usr/local/airflow/functions/"}"
: "${FUNCTION_NAME:="load_data_into_bigquery"}"
: "${FUNCTION_JOB:="load_data_into_bigquery.zip"}"

# Pub/Sub
: "${TOPIC_ID="datawarehouse-lab"}"
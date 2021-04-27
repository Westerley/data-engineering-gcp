#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

gcloud dataproc clusters create ${CLUSTER_NAME} \
    --region=${REGION} \
    --zone=${ZONE} \
    --image-version=2.0 \
    --scopes=default,sql-admin \
    --master-machine-type=${MASTER_MACHINE_TYPE} \
    --master-boot-disk-size=${MASTER_BOOT_DISK} \
    --num-workers=${NUM_WORKERS} \
    --worker-machine-type=${WORKER_MACHINE_TYPE} \
    --worker-boot-disk-size=${WORKER_BOOT_DISK} \
    --bucket=${BUCKET_NAME} \
    --optional-components=ANACONDA,JUPYTER \
    --enable-component-gateway \
    --tags=lab \
    --metadata 'PIP_PACKAGES=google-cloud-storage'

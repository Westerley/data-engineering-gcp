#!/usr/bin/env bash

source ./variables.sh

gcloud dataproc clusters delete ${CLUSTER_NAME} \
    --region=${REGION} \
    --async \
    --quiet
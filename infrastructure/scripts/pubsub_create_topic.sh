#!/usr/bin/env bash

source ./usr/local/airflow/scripts/variables.sh

gcloud pubsub topics create ${TOPIC_ID}


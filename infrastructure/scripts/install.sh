#!/bin/bash

source ./variables.sh

# Dataproc
./dataproc_create_cluster.sh
./dataproc_submit_pyspark.sh
./dataproc_delete_cluster.sh

# Function
./function_deploy.sh

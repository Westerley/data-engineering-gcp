import os
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocCreateClusterOperator,
    DataprocSubmitJobOperator,
    DataprocDeleteClusterOperator
)
from airflow.utils.trigger_rule import TriggerRule

PROJECT_ID = "dataengineer-310515"
CLUSTER_NAME = "dataproc-lab"
REGION = "us-east1"

DEFAULT_ARGS = {
    'owner': 'Westerley Reis',
    "depends_on_past": False,
    "start_date": datetime(2020, 4, 25),
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0
}

CLUSTER_CONFIG = {
    "master_config": {
        "num_instances": 1,
        "machine_type_uri": "n1-standard-2",
        "disk_config": {"boot_disk_type": "pd-standard", "boot_disk_size_gb": 1024},
    },
    "worker_config": {
        "num_instances": 2,
        "machine_type_uri": "n1-standard-2",
        "disk_config": {"boot_disk_type": "pd-standard", "boot_disk_size_gb": 1024},
    },
}

PYSPARK_JOB = {
    "reference": {"project_id": PROJECT_ID},
    "placement": {"cluster_name": CLUSTER_NAME},
    "pyspark_job": {"main_python_file_uri": "/usr/local/airflow/jobs/titanic_job.py"}
}

dag = DAG(
    dag_id="dataproc_dag",
    default_args=DEFAULT_ARGS,
    catchup=False
)

dataproc_create_cluster = DataprocCreateClusterOperator(
    task_id="dataproc_create_cluster",
    project_id=PROJECT_ID,
    cluster_name=CLUSTER_NAME,
    region=REGION,
    cluster_config=CLUSTER_CONFIG,
    dag=dag
)

dataproc_submit_job = BashOperator(
    task_id="dataproc_submit_job",
    bash_command=" \
    /google-cloud-sdk/bin/gcloud config set account {{ params.account_name }} && \
    /google-cloud-sdk/bin/gcloud config set project {{ params.project_id }} && \
    /google-cloud-sdk/bin/gcloud auth activate-service-account {{ params.account_name }} \
        --key-file=/usr/local/airflow/service-account.json && \
    /google-cloud-sdk/bin/gcloud dataproc jobs submit pyspark \
    /usr/local/airflow/jobs/titanic_job.py \
    --cluster={{ params.cluster_name }} \
    --region={{ params.region }} \
    ",
    params={"cluster_name": CLUSTER_NAME,
            "project_id": PROJECT_ID,
            "region": REGION,
            "account_name": "airflow@dataengineer-310515.iam.gserviceaccount.com"},
    dag=dag
)

rename_tickets_parquet = BashOperator(
    task_id="rename_tickets_parquet",
    bash_command="gsutil mv gs://datalake-lab/processing_zone/passengers.parquet/*.parquet gs://datalake-lab/processing_zone/passengers.parquet/passengers.parquet",
    dag=dag
)

# dataproc_submit_job = DataprocSubmitJobOperator(
#     task_id="dataproc_submit_job",
#     project_id=PROJECT_ID,
#     location=REGION,
#     job=PYSPARK_JOB,
#     dag=dag
# )

dataproc_delete_cluster = DataprocDeleteClusterOperator(
    task_id="dataproc_delete_cluster",
    project_id=PROJECT_ID,
    cluster_name=CLUSTER_NAME,
    region=REGION,
    trigger_rule=TriggerRule.ALL_DONE,
    dag=dag
)

dataproc_create_cluster >> dataproc_submit_job >> dataproc_delete_cluster

import os
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

ACCOUNT_NAME = "airflow@dataengineer-310515.iam.gserviceaccount.com"
PROJECT_ID = "dataengineer-310515"

DEFAULT_ARGS = {
    'owner': 'Westerley Reis',
    "depends_on_past": False,
    "start_date": datetime(2020, 11, 10),
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0
}

dag = DAG(
    dag_id="dataproc_bash_dag",
    default_args=DEFAULT_ARGS,
    catchup=False
)

# todo Corrigir a instalação do gcloud no docker, para executar o comando é preciso especifiar o caminho inteiro
# todo /google-cloud-sdk/bin/gcloud config set account {{ params.account_name }}
set_account = BashOperator(
    task_id="set_account",
    bash_command=" \
        /google-cloud-sdk/bin/gcloud config set account {{ params.account_name }} && \
        /google-cloud-sdk/bin/gcloud config set project {{ params.project_id }} && \
        /google-cloud-sdk/bin/gcloud auth activate-service-account {{ params.account_name }} \
            --key-file=/usr/local/airflow/service-account.json",
    params={"project_id": PROJECT_ID,
            "account_name": ACCOUNT_NAME},
    dag=dag
)

dataproc_create_cluster = BashOperator(
    task_id="dataproc_create_cluster",
    bash_command="bash ./usr/local/airflow/infrastructure/scripts/dataproc_create_cluster.sh",
    dag=dag
)

submit_pyspark_job = BashOperator(
    task_id="dataproc_create_cluster",
    bash_command="bash ./usr/local/airflow/infrastructure/scripts/submit_pyspark_to_dataproc.sh",
    dag=dag
)

rename_tickets_parquet = BashOperator(
    task_id="rename_tickets_parquet",
    bash_command=" \
                 gsutil mv gs://{{ datalake }}/processing_zone/passengers.parquet/*.parquet \
                 gs://{{ datalake }}/processing_zone/passengers.parquet/passengers.parquet",
    params={"datalake": "datalake-lab"},
    dag=dag
)

dataproc_delete_cluster = BashOperator(
    task_id="dataproc_create_cluster",
    bash_command="bash ./usr/local/airflow/infrastructure/scripts/dataproc_delete_cluster.sh",
    dag=dag
)

set_account >> dataproc_create_cluster >> submit_pyspark_job >> rename_tickets_parquet >> dataproc_delete_cluster

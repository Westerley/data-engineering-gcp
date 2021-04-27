from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.providers.google.cloud.sensors.gcs import GCSObjectExistenceSensor


PROJECT_ID = "dataengineer-310515"
BUCKET = "datalake-lab"
DATASET = "datawarehouse"


DEFAULT_ARGS = {
    'owner': 'Westerley Reis',
    "depends_on_past": False,
    "schedule_interval": "@daily",
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0,
    "retry_delay": timedelta(minutes=1)
}

dag = DAG(
    dag_id="datalake_to_bigquery",
    default_args=DEFAULT_ARGS,
    start_date=datetime(2020, 4, 25),
    catchup=False
)

check_file_sensor = GCSObjectExistenceSensor(
    task_id='check_file_sensor',
    bucket=BUCKET,
    object='processing_zone/tickets.parquet/tickets.parquet',
    timeout=60, #timeout in 1 min
    poke_interval=20, #checking file every 20 seconds
    soft_fail=True #skip tasks if it is False
)

load_tickets = GCSToBigQueryOperator(
    task_id="load_customers",
    bucket=BUCKET,
    source_objects=["processing_zone/tickets.parquet/tickets.parquet"],
    destination_project_dataset_table=f"{PROJECT_ID}:{DATASET}.tb_tickets",
    write_disposition="WRITE_APPEND",
    source_format="PARQUET",
    skip_leading_rows=1,
    dag=dag
)

check_file_sensor >> load_tickets

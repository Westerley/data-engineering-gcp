import os

from google.cloud import bigquery
from google.cloud import storage

BUCKET_NAME = os.getenv("bucket_name")
DATASET_NAME = os.getenv("dataset_name")
FILENAME = os.getenv("filename")
TABLE_NAME = os.getenv("table_name")
job_config = bigquery.LoadJobConfig()
bigquery_client = bigquery.Client()
storage_client = storage.Client()


def fn_load_data_into_bigquery(event, context):
    """

    :param event:
    :param context:
    :return:
    """
    path, filename = os.path.split(event["name"])

    if path.split("/")[-1] == "processing_zone" and filename == FILENAME:
        blob = storage_client.get_bucket(BUCKET_NAME).blob(filename)
        table = bigquery_client.get_dataset(dataset_ref=DATASET_NAME).table(table_id=TABLE_NAME)

        job_config.write_disposition = "WRITE_APPEND"
        job_config.source_format = bigquery.SourceFormat.PARQUET

        job = bigquery_client.load_table_from_file(
            file_obj=blob,
            destination=table,
            job_config=job_config
        )
        job.result()
        print("Job finished!")

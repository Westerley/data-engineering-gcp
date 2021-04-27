resource "null_resource" "fn_stage" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "zip -urj ../../functions/load_data_into_rawzone.zip ../../functions/load_data_into_rawzone && zip -urj ../../functions/load_data_into_bigquery.zip ../../functions/load_data_into_bigquery"
  }
}

resource "google_storage_bucket_object" "fn_bucket" {
  name   = "load_data_into_rawzone.zip"
  bucket = var.fn_bucket
  source = "../../functions/load_data_into_rawzone.zip"
  depends_on = [null_resource.fn_stage]
}

resource "google_cloudfunctions_function" "fn_download_data_into_rawzone" {
  name                  = "fn_download_data_into_rawzone"
  project               = var.project
  runtime               = "python38"
  available_memory_mb   = 2048
  source_archive_bucket = google_storage_bucket_object.fn_bucket.bucket
  source_archive_object = google_storage_bucket_object.fn_bucket.name
  timeout               = 540
  entry_point           = "fn_download_data_into_rawzone"

  environment_variables = {
    bucket_name = "datalake-lab"
    folder_zone = "raw_zone"
  }

  depends_on = [google_storage_bucket_object.fn_bucket]

  event_trigger {
      event_type  = "google.pubsub.topic.publish"
      resource    = "projects/${var.project}/topics/cloud-builds-topic"
      failure_policy {
        retry = false
      }
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.fn_download_data_into_rawzone.project
  region         = google_cloudfunctions_function.fn_download_data_into_rawzone.region
  cloud_function = google_cloudfunctions_function.fn_download_data_into_rawzone.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_storage_bucket_object" "fn_bucket_bigquery" {
  name   = "load_data_into_bigquery.zip"
  bucket = var.fn_bucket
  source = "../../functions/load_data_into_bigquery.zip"
  depends_on = [null_resource.fn_stage]
}

resource "google_cloudfunctions_function" "fn_load_data_into_bigquery" {
  name                  = "fn_load_data_into_bigquery"
  project               = var.project
  runtime               = "python38"
  available_memory_mb   = 2048
  source_archive_bucket = google_storage_bucket_object.fn_bucket_bigquery.bucket
  source_archive_object = google_storage_bucket_object.fn_bucket_bigquery.name
  timeout               = 540
  entry_point           = "fn_load_data_into_bigquery"

  environment_variables = {
    bucket_name   = "datalake-lab"
    folder_zone   = "processing_zone"
    dataset_name  = "datawarehouse"
    filename      = "passengers.parquet"
    table_name    = "tb_passengers"
  }

  depends_on = [google_storage_bucket_object.fn_bucket_bigquery]

  event_trigger {
    event_type  = "google.storage.object.finalize"
    resource    = var.datalake
  }
}
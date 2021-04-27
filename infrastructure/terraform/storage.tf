resource "google_storage_bucket" "datalake" {
  project       = var.project
  name          = var.datalake
  location      = var.region
  storage_class = "STANDARD"
  labels        = {"storage": "datalake"}
  force_destroy = true
}

resource "google_storage_bucket_object" "raw_zone" {
  bucket  = google_storage_bucket.datalake.name
  name    = "raw_zone/"
  source  = "/dev/null"
}

resource "google_storage_bucket_object" "processing_zone" {
  bucket  = google_storage_bucket.datalake.name
  name    = "processing_zone/"
  source  = "/dev/null"
}

resource "google_storage_bucket_object" "consumer_zone" {
  bucket  = google_storage_bucket.datalake.name
  name    = "consumer_zone/"
  source  = "/dev/null"
}

resource "google_storage_bucket" "bucket_devops" {
  project       = var.project
  name          = var.fn_bucket
  location      = var.region
  storage_class = "STANDARD"
  labels        = {"storage": "bucket_devops"}
  force_destroy = true
}
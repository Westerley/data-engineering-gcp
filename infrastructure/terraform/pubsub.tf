resource "google_pubsub_topic" "topic" {
  name = var.pubsub_name
  project = var.project
}
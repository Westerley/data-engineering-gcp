resource "google_bigquery_dataset" "default" {
  for_each                    = local.datasets
  project                     = var.project
  dataset_id                  = each.key
  friendly_name               = each.key
  description                 = each.value["description"]
  location                    = var.region
  delete_contents_on_destroy  = true
}

resource "google_bigquery_table" "tables" {
  for_each        = local.tables
  dataset_id      = each.value["dataset_id"]
  friendly_name   = each.key
  table_id        = each.key
  schema          = file(each.value["schema"])
  project         = var.project
}
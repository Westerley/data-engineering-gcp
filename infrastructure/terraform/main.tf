provider "google" {
  credentials  = file("../../config/service-account.json")
  region  = var.region
  zone    = var.zone
}

#carregar variaveis locais
locals {
  tables = { for i, table in var.tables : table["table_id"] => table }
  datasets = { for i, dataset in var.datasets : dataset["dataset_id"] => dataset }
}
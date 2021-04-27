variable "project" {
  default = "dataengineer-310515"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "datalake" {
  default = "datalake-lab"
}

variable "fn_bucket" {
  default     = "fn_bucket_devops"
}

variable "pubsub_name" {
  default = "datawarehouse-lab"
}

variable "datasets" {
  description = "A list of dataset that includes dataset_id, description"
  default     = []
  type = list(object({
    dataset_id   = string,
    description  = string,
  }))
}

variable "tables" {
  description = "A list of maps that includes table_id, schema in each element."
  default     = []
  type = list(object({
    table_id   = string,
    schema     = string,
    dataset_id = string,
  }))
}
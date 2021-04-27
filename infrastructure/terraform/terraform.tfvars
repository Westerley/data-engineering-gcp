datasets = [
  {
    dataset_id          = "datawarehouse"
    description         = "Contém as tabelas do dw"
  }
]

tables = [
  {
    table_id          = "tb_passengers",
    schema            = "../../schemas/passenger_schema.json",
    dataset_id        = "datawarehouse"
  },
  {
    table_id          = "tb_tickets",
    schema            = "../../schemas/ticket_schema.json",
    dataset_id        = "datawarehouse"
  }
]
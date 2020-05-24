variable "aws_region" {
  default     = "eu-west-1"
  description = "Region to create the AppSync resources under"
}

variable "appsync_name" {
  default     = "Excrum"
  description = "Name of the AppSync instance, and also used to prefix resources"
}

variable "datasource_name" {
  default     = "excrum_members_table"
  description = "Name of the data source to be created"
}

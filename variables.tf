variable "aws_region" {
  default     = "eu-west-1"
  description = "Region to create the AppSync resources under"
}

variable "appsync_name" {
  default     = "Excrum"
  description = "Name of the AppSync instance, and also used to prefix resources"
}

variable "datasource_members" {
  default     = "excrum_members_table"
  description = "Storing scrum members"
}

variable "datasource_teams" {
  default     = "excrum_teams_table"
  description = "Storing scrum teams"
}

variable "datasource_sprints" {
  default     = "excrum_sprints_table"
  description = "Storing scrum sprints"
}

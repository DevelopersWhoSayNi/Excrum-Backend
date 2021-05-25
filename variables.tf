variable "aws_region" {
  default     = "eu-west-1"
  description = "Region to create the Excrum resources under"
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

variable "handler" {
  default = "handler.lambda_handler"
}

variable "runtime" {
  default = "python3.8"
}

variable "memory_size" {
  default = 128
}

variable "timeout" {
  default = "30"
}

variable "default_tags" {
  type        = map(string)
  description = ""

  default = {
    Terraform   = "true"
    GitHub-Repo = "https://github.com/DevelopersWhoSayNi/Excrum-Backend"
  }
}

variable "memory_alert_threshold" {
  default = "120"
}

variable "alarm_action_arn" {
  default = ""
}

variable "ok_action_arn" {
  default = ""
}

variable "monitoring_enabled" {
  default = 1
}

variable "iteratorage_monitoring_enabled" {
  default = false
}

variable "iteratorage_threshold_ms" {
  default = 600000
}

variable "log_group_retention_days" {
  default = 30
}

variable "bucket_name" {
  default = "excrum-prod"
}
variable "members_resource_name" {
  default = "members"
}
variable "sprints_resource_name" {
  default = "sprints"
}
variable "teams_resource_name" {
  default = "teams"
}
variable "excrum_stage" {
  default = "dev"
}

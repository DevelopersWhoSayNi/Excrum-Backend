locals {
  name_prefix           = ""
  appsync_name          = "${local.name_prefix}${var.appsync_name}"
  datasource_members    = "${local.name_prefix}_${var.datasource_members}"
  datasource_teams      = "${local.name_prefix}_${var.datasource_teams}"
  datasource_sprints    = "${local.name_prefix}_${var.datasource_sprints}"
  excrum_members_lambda = "${local.name_prefix}-excrum-member-lambda"
}
locals {
  name_prefix           = "mari"
  appsync_name          = "${local.name_prefix}${var.appsync_name}"
  datasource_members    = "${local.name_prefix}_${var.datasource_members}"
  datasource_teams      = "${local.name_prefix}_${var.datasource_teams}"
  datasource_sprints    = "${local.name_prefix}_${var.datasource_sprints}"
  excrum_members_lambda = "${local.name_prefix}-excrum-members-lambda"
  excrum_sprint_lambda = "${local.name_prefix}-excrum-sprints-lambda"
  excrum_teams_lambda = "${local.name_prefix}-excrum-teams-lambda"
}
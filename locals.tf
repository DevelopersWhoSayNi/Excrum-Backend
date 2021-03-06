locals {
  name_prefix               = "prod"
  datasource_members        = "${local.name_prefix}_${var.datasource_members}"
  datasource_teams          = "${local.name_prefix}_${var.datasource_teams}"
  datasource_sprints        = "${local.name_prefix}_${var.datasource_sprints}"
  excrum_members_lambda     = "${local.name_prefix}-excrum-members-lambda"
  excrum_sprint_lambda      = "${local.name_prefix}-excrum-sprints-lambda"
  excrum_teams_lambda       = "${local.name_prefix}-excrum-teams-lambda"
  excrum_gateway_key        = "${local.name_prefix}-excrum-gateway-key"
  excrum_gateway_usage_plan = "${local.name_prefix}-excrum-gateway-usage-plan"
  excrum_rest_api           = "${local.name_prefix}-Excrum"
}
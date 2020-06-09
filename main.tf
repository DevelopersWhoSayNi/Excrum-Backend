provider "aws" {
  region = var.aws_region
}

resource "aws_appsync_graphql_api" "excrum" {
  name                = var.appsync_name
  authentication_type = "API_KEY"
}

resource "aws_appsync_api_key" "excrum_api" {
  api_id = aws_appsync_graphql_api.excrum.id
}

resource "aws_appsync_datasource" "members" {
  api_id           = aws_appsync_graphql_api.excrum.id
  name             = var.datasource_members
  service_role_arn = aws_iam_role.api.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.members.name
  }
}

resource "aws_appsync_datasource" "teams" {
  api_id           = aws_appsync_graphql_api.excrum.id
  name             = var.datasource_teams
  service_role_arn = aws_iam_role.api.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.teams.name
  }
}

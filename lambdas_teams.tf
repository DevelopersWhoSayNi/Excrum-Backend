resource "aws_lambda_function" "excrum_teams_lambda" {
  function_name    = local.excrum_teams_lambda
  description      = "Lambda that retrieves the team teams"
  role             = aws_iam_role.iam_excrum_teams_lambda.arn
  filename         = data.archive_file.teams_lambda_archive_file.output_path
  source_code_hash = data.archive_file.teams_lambda_archive_file.output_base64sha256

  handler     = var.handler
  runtime     = var.runtime
  memory_size = var.memory_size
  timeout     = var.timeout

  environment {
    variables = {
      TEAMS_TABLE_NAME = local.datasource_teams
    }
  }

  tags = var.default_tags
}

resource "aws_iam_role" "iam_excrum_teams_lambda" {
  name               = local.excrum_teams_lambda
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "iam_policy_for_excrum_teams_lambda" {
  name   = local.excrum_teams_lambda
  role   = aws_iam_role.iam_excrum_teams_lambda.id
  policy = data.aws_iam_policy_document.lambda_invoke_excrum_teams_iam_policy_document.json
}

data "aws_iam_policy_document" "lambda_invoke_excrum_teams_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "apigateway:*",
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:Scan"
    ]

    resources = [
      aws_dynamodb_table.teams_dynamodb.arn
    ]
  }
}


data "null_data_source" "teams_lambda_file" {
  inputs = {
    filename = "${path.module}/lambda_functions/teams_lambda/handler.py"
  }
}

data "null_data_source" "teams_lambda_file_archive" {
  inputs = {
    filename = "${path.module}/lambda_functions/teams_lambda.zip"
  }
}

data "archive_file" "teams_lambda_archive_file" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/teams_lambda/handler.py"
  output_path = "${path.module}/lambda_functions/teams_lambda.zip"
}

module "lambda_app_cloudwatch_teams" {
  source                          = "./cloudwatch_lambda_monitoring"
  app_name                        = local.excrum_teams_lambda
  log_group_name                  = "/aws/lambda/${local.excrum_teams_lambda}"
  cloudwatch_alarm_threshold      = var.memory_alert_threshold
  cloudwatch_alarm_action_arn     = var.alarm_action_arn
  ok_action_arn                   = var.ok_action_arn
  log_group_retention_days        = var.log_group_retention_days
  cloudwatch_monitoring_enabled   = var.monitoring_enabled
  iterator_age_alarm_enabled      = var.iteratorage_monitoring_enabled
  iterator_age_alarm_threshold_ms = var.iteratorage_threshold_ms
  tags                            = var.default_tags
}

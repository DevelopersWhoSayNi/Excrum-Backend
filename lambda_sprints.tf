resource "aws_lambda_function" "excrum_sprints_lambda" {
  function_name    = local.excrum_sprint_lambda
  description      = "Lambda that retrieves the team sprint"
  role             = aws_iam_role.iam_excrum_sprint_lambda.arn
  filename         = data.archive_file.sprint_lambda_archive_file.output_path
  source_code_hash = data.archive_file.sprint_lambda_archive_file.output_base64sha256

  handler     = var.handler
  runtime     = var.runtime
  memory_size = var.memory_size
  timeout     = var.timeout

  environment {
    variables = {
      SPRINTS_TABLE_NAME = local.datasource_sprints
    }
  }

  tags = var.default_tags
}

resource "aws_iam_role" "iam_excrum_sprint_lambda" {
  name               = local.excrum_sprint_lambda
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "iam_policy_for_excrum_sprint_lambda" {
  name   = local.excrum_sprint_lambda
  role   = aws_iam_role.iam_excrum_sprint_lambda.id
  policy = data.aws_iam_policy_document.lambda_invoke_excrum_sprint_iam_policy_document.json
}

data "aws_iam_policy_document" "lambda_invoke_excrum_sprint_iam_policy_document" {
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
      "dynamodb:*"
    ]

    resources = [
      aws_dynamodb_table.sprints_dynamodb.arn
    ]
  }
}


data "null_data_source" "sprint_lambda_file" {
  inputs = {
    filename = "${path.module}/lambda_functions/sprints_lambda/handler.py"
  }
}

data "null_data_source" "sprint_lambda_file_archive" {
  inputs = {
    filename = "${path.module}/lambda_functions/sprints_lambda.zip"
  }
}

data "archive_file" "sprint_lambda_archive_file" {
  type        = "zip"
  source_file = "${path.module}/lambda_functions/sprints_lambda/handler.py"
  output_path = "${path.module}/lambda_functions/sprints_lambda.zip"
}

module "lambda_app_cloudwatch_sprint" {
  source                          = "./cloudwatch_lambda_monitoring"
  app_name                        = local.excrum_sprint_lambda
  log_group_name                  = "/aws/lambda/${local.excrum_sprint_lambda}"
  cloudwatch_alarm_threshold      = var.memory_alert_threshold
  cloudwatch_alarm_action_arn     = var.alarm_action_arn
  ok_action_arn                   = var.ok_action_arn
  log_group_retention_days        = var.log_group_retention_days
  cloudwatch_monitoring_enabled   = var.monitoring_enabled
  iterator_age_alarm_enabled      = var.iteratorage_monitoring_enabled
  iterator_age_alarm_threshold_ms = var.iteratorage_threshold_ms
  tags                            = var.default_tags
}

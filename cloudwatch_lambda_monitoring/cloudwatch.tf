resource "aws_cloudwatch_log_group" "lambda_log_group" {
  # count = var.resource_count

  name              = "/aws/lambda/${var.app_name}"
  retention_in_days = var.log_group_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_metric_filter" "lambda_memory_metric" {
  # count = var.resource_count

  name = "${var.app_name}_memory_metric_filter"

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]

  pattern        = var.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "${var.app_name}-memory-used"
    namespace = var.aws_cloudwatch_metric_alarm_namespace
    value     = "$max_memory_used_value"
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_monitoring_metric" {
  # count = var.resource_count

  alarm_name                = "${var.app_name}_lambda_memory_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  datapoints_to_alarm       = "1"
  metric_name               = "${var.app_name}-memory-used"
  namespace                 = var.aws_cloudwatch_metric_alarm_namespace
  period                    = var.default_period
  statistic                 = "Maximum"
  threshold                 = var.cloudwatch_alarm_threshold
  alarm_description         = "Alert on memory usage of lambda function ${var.app_name}"
  insufficient_data_actions = []
  
  actions_enabled    = var.alarm_action_enabled
  treat_missing_data = "notBreaching"

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "error_monitoring_metric" {
  # count = var.resource_count

  alarm_name          = "${var.app_name}_lambda_error_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = var.default_period
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alert on errors in lambda function ${var.app_name}"

  dimensions = {
    FunctionName = var.app_name
  }

  treat_missing_data = "notBreaching"

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "streamalert_lambda_iterator_age" {
  count = var.iterator_age_alarm_enabled ? 1 : 0

  alarm_name          = "${var.app_name}_iterator_age_alarm"
  namespace           = "AWS/Lambda"
  metric_name         = "IteratorAge"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.iterator_age_alarm_threshold_ms
  evaluation_periods  = 1
  period              = var.iterator_age_alarm_period_secs
  alarm_description   = "Lambda High Iterator Age: ${var.app_name}"

  dimensions = {
    FunctionName = var.app_name
  }

  treat_missing_data = "notBreaching"

  tags = var.tags
}


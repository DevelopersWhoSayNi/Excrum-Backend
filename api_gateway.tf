# API Gateway Configuration

resource "aws_api_gateway_rest_api" "excrum_rest_api" {
  name = local.excrum_rest_api

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.default_tags
}

resource "aws_api_gateway_deployment" "excrum_deployment" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.excrum_members_method
  ]
}

resource "aws_api_gateway_api_key" "excrum_gateway_key" {
  name        = local.excrum_gateway_key
  description = "Api Key created for Excrum endpoint"
}

resource "aws_api_gateway_usage_plan" "excrum_usage_plan" {
  name        = local.excrum_gateway_usage_plan
  description = "Used for Excrum endpoint"

  api_stages {
    api_id = aws_api_gateway_rest_api.excrum_rest_api.id
    stage  = aws_api_gateway_stage.excrum_stage.stage_name
  }

  throttle_settings {
    burst_limit = 1000
    rate_limit  = 1000
  }
}

resource "aws_api_gateway_usage_plan_key" "excrum_api_gateway_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.excrum_gateway_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.excrum_usage_plan.id
}

resource "aws_api_gateway_stage" "excrum_stage" {
  depends_on    = [aws_api_gateway_deployment.excrum_deployment]
  stage_name    = var.excrum_stage
  rest_api_id   = aws_api_gateway_rest_api.excrum_rest_api.id
  deployment_id = aws_api_gateway_deployment.excrum_deployment.id

}

# GET Members Lambda Integration
resource "aws_api_gateway_resource" "excrum_members_resource" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  parent_id   = aws_api_gateway_rest_api.excrum_rest_api.root_resource_id
  path_part   = var.members_resource_name
}

resource "aws_api_gateway_method" "excrum_members_method" {
  rest_api_id      = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id      = aws_api_gateway_resource.excrum_members_resource.id
  http_method      = "POST"
  authorization    = "None"
  api_key_required = false
}

resource "aws_lambda_permission" "excrum_members_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.excrum_members_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.excrum_rest_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_integration" "excrum_members_integration" {
  rest_api_id             = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id             = aws_api_gateway_resource.excrum_members_resource.id
  http_method             = aws_api_gateway_method.excrum_members_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.excrum_members_lambda.arn}/invocations"
}

resource "aws_api_gateway_method_response" "excrum_members_method_response" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id = aws_api_gateway_resource.excrum_members_resource.id
  http_method = aws_api_gateway_method.excrum_members_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "excrum_members_response" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id = aws_api_gateway_resource.excrum_members_resource.id
  http_method = aws_api_gateway_method.excrum_members_method.http_method

  status_code = aws_api_gateway_method_response.excrum_members_method_response.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.excrum_members_integration]
}


# POST Sprints Lambda Integration
resource "aws_api_gateway_resource" "excrum_sprints_resource" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  parent_id   = aws_api_gateway_rest_api.excrum_rest_api.root_resource_id
  path_part   = var.sprints_resource_name
}

resource "aws_api_gateway_method" "excrum_sprints_method" {
  rest_api_id      = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id      = aws_api_gateway_resource.excrum_sprints_resource.id
  http_method      = "POST"
  authorization    = "None"
  api_key_required = false
}

resource "aws_lambda_permission" "excrum_sprints_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.excrum_sprints_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.excrum_rest_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_integration" "excrum_sprints_integration" {
  rest_api_id             = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id             = aws_api_gateway_resource.excrum_sprints_resource.id
  http_method             = aws_api_gateway_method.excrum_sprints_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.excrum_sprints_lambda.arn}/invocations"
}

resource "aws_api_gateway_method_response" "excrum_sprints_method_response" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id = aws_api_gateway_resource.excrum_sprints_resource.id
  http_method = aws_api_gateway_method.excrum_sprints_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "excrum_sprints_response" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id = aws_api_gateway_resource.excrum_sprints_resource.id
  http_method = aws_api_gateway_method.excrum_sprints_method.http_method

  status_code = aws_api_gateway_method_response.excrum_sprints_method_response.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.excrum_sprints_integration]
}

# # GET Sprints List Lambda Integration

# # resource "aws_api_gateway_resource" "excrum_sprints_resource" {
# #   rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
# #   parent_id   = aws_api_gateway_rest_api.excrum_rest_api.root_resource_id
# #   path_part   = var.sprints_resource_name
# # }

# resource "aws_api_gateway_method" "excrum_sprints_method" {
#   rest_api_id      = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id      = aws_api_gateway_resource.excrum_sprints_resource.id
#   http_method      = "GET"
#   authorization    = "None"
#   api_key_required = false
# }

# # resource "aws_lambda_permission" "excrum_sprints_lambda_permission" {
# #   statement_id  = "AllowExecutionFromAPIGateway"
# #   action        = "lambda:InvokeFunction"
# #   function_name = aws_lambda_function.excrum_sprints_lambda.arn
# #   principal     = "apigateway.amazonaws.com"

# #   source_arn = "${aws_api_gateway_rest_api.excrum_rest_api.execution_arn}/*/*/*"
# # }

# resource "aws_api_gateway_integration" "excrum_sprintslist_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id             = aws_api_gateway_resource.excrum_sprints_resource.id
#   http_method             = aws_api_gateway_method.excrum_sprints_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS"
#   uri                     = "arn:aws:apigateway:${var.region}:dynamodb:action/BatchGetItem"

#   credentials = aws_iam_role.cashflow_api_integration_role.arn
#   request_templates = {
#     "application/json" = <<EOF
# {
#     "RequestItems":{ "$${stageVariables.dynamoDB_table}": {
#             "Keys": [
#                     #foreach($elem in $input.path('$').divisions)
#                     {
#                     "Division": {
#                         "N":"$elem"}
#                     }#if($foreach.hasNext),#end
#                     #end
#             ]
#         }
#     }   
# }
# EOF
#   }
# }

# resource "aws_api_gateway_method_response" "excrum_sprints_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id = aws_api_gateway_resource.excrum_sprints_resource.id
#   http_method = aws_api_gateway_method.excrum_sprints_method.http_method
#   status_code = "200"

#   response_models = {
#     "application/json" = "Empty"
#   }

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = false
#   }
# }

# resource "aws_api_gateway_integration_response" "excrum_sprints_response" {
#   rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id = aws_api_gateway_resource.excrum_sprints_resource.id
#   http_method = aws_api_gateway_method.excrum_sprints_method.http_method

#   status_code = aws_api_gateway_method_response.excrum_sprints_method_response.status_code

#   response_templates = {
#     "application/json" = ""
#   }

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin" = "'*'"
#   }

#   depends_on = [aws_api_gateway_integration.excrum_sprints_integration]
# }

# POST Teams Lambda Integration
resource "aws_api_gateway_resource" "excrum_teams_resource" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  parent_id   = aws_api_gateway_rest_api.excrum_rest_api.root_resource_id
  path_part   = var.teams_resource_name
}

resource "aws_api_gateway_method" "excrum_teams_method" {
  rest_api_id      = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id      = aws_api_gateway_resource.excrum_teams_resource.id
  http_method      = "POST"
  authorization    = "None"
  api_key_required = false
}

resource "aws_lambda_permission" "excrum_teams_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.excrum_teams_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.excrum_rest_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_integration" "excrum_teams_integration" {
  rest_api_id             = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id             = aws_api_gateway_resource.excrum_teams_resource.id
  http_method             = aws_api_gateway_method.excrum_teams_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.excrum_teams_lambda.arn}/invocations"
}

resource "aws_api_gateway_method_response" "excrum_teams_method_response" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id = aws_api_gateway_resource.excrum_teams_resource.id
  http_method = aws_api_gateway_method.excrum_teams_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "excrum_teams_response" {
  rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
  resource_id = aws_api_gateway_resource.excrum_teams_resource.id
  http_method = aws_api_gateway_method.excrum_teams_method.http_method

  status_code = aws_api_gateway_method_response.excrum_teams_method_response.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [aws_api_gateway_integration.excrum_teams_integration]
}


# resource "aws_api_gateway_method" "members_cors_method" {
#   rest_api_id      = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id      = aws_api_gateway_resource.excrum_members_resource.id
#   http_method      = "OPTIONS"
#   authorization    = "None"
#   api_key_required = true
# }

# resource "aws_api_gateway_integration" "members_integration" {
#   rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id = aws_api_gateway_resource.excrum_members_resource.id
#   http_method = aws_api_gateway_method.members_cors_method.http_method
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = <<EOF
#   { "statusCode": 200 }

# EOF

#   }
# }

# resource "aws_api_gateway_method_response" "eol_with_iam_authorization_cors_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id = aws_api_gateway_resource.excrum_resource_with_iam_authorization.id
#   http_method = aws_api_gateway_method.eol_with_iam_authorization_cors_method.http_method

#   status_code = "200"

#   response_models = {
#     "application/json" = "Empty"
#   }

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = false
#     "method.response.header.Access-Control-Allow-Methods" = false
#     "method.response.header.Access-Control-Allow-Origin"  = false
#   }
# }

# resource "aws_api_gateway_integration_response" "excrum_with_iam_authorization_cors_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.excrum_rest_api.id
#   resource_id = aws_api_gateway_method.eol_with_iam_authorization_cors_method.resource_id
#   http_method = aws_api_gateway_method.eol_with_iam_authorization_cors_method.http_method

#   status_code = aws_api_gateway_method_response.eol_with_iam_authorization_cors_method_response.status_code

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
#     "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }
# }


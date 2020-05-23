/**
 * Points of interest:
 *  - Each resolver has an explicit depends_on for the datasource, this is because the datasource doesn't expose its
 *    name as output so we are forced to reference the datasource_name variable, removing Terraform's ability to infer
 *    a dependency of this resource on the datasource's creation.
 */

data "local_file" "cloudformation_resolver_template" {
  filename = "${path.module}/scripts/cloudformation/templates/resolver.json"
}

## List Members

data "local_file" "list_members_request_mapping" {
  filename = "${path.module}/scripts/api/members/listMembers-request-mapping-template.txt"
}

data "local_file" "list_members_response_mapping" {
  filename = "${path.module}/scripts/api/members/listMembers-response-mapping-template.txt"
}

resource "aws_cloudformation_stack" "list_members_resolver" {
  depends_on = [
    aws_appsync_datasource.members,
    aws_cloudformation_stack.api_schema
  ]

  name = "${var.appsync_name}-list-members-resolver"

  parameters = {
    graphQlApiId            = aws_appsync_graphql_api.excrum.id
    dataSourceName          = var.datasource_name
    fieldName               = "listMembers"
    typeName                = "Query"
    requestMappingTemplate  = data.local_file.list_members_request_mapping.content
    responseMappingTemplate = data.local_file.list_members_response_mapping.content
  }

  template_body = data.local_file.cloudformation_resolver_template.content
}

# Create Members

data "local_file" "create_source_request_mapping" {
  filename = "${path.module}/scripts/api/members/createMembers-request-mapping-template.txt"
}

data "local_file" "create_source_response_mapping" {
  filename = "${path.module}/scripts/api/members/createMembers-response-mapping-template.txt"
}

resource "aws_cloudformation_stack" "create_members_resolver" {
  depends_on = [
    aws_appsync_datasource.members,
    aws_cloudformation_stack.api_schema
  ]
  name = "${var.appsync_name}-create-members-resolver"

  parameters = {
    graphQlApiId            = aws_appsync_graphql_api.excrum.id
    dataSourceName          = var.datasource_name
    fieldName               = "createMembers"
    typeName                = "Mutation"
    requestMappingTemplate  = data.local_file.create_source_request_mapping.content
    responseMappingTemplate = data.local_file.create_source_response_mapping.content
  }

  template_body = data.local_file.cloudformation_resolver_template.content
}

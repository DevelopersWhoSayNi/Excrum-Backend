/**
 * Points of interest:
 *  - Each resolver has an explicit depends_on for the datasource, this is because the datasource doesn't expose its
 *    name as output so we are forced to reference the datasource_[name] variable, removing Terraform's ability to infer
 *    a dependency of this resource on the datasource's creation.
 */

data "local_file" "cloudformation_resolver_template" {
  filename = "${path.module}/scripts/cloudformation/templates/resolver.json"
}

## List Members

data "local_file" "list_members_request_mapping" {
  filename = "${path.module}/scripts/api/members/list_member_request.txt"
}

data "local_file" "list_members_response_mapping" {
  filename = "${path.module}/scripts/api/members/list_member_response.txt"
}

resource "aws_cloudformation_stack" "list_members_resolver" {
  depends_on = [
    aws_appsync_datasource.members,
    aws_cloudformation_stack.api_schema
  ]

  name = "${local.appsync_name}-list-members-resolver"

  parameters = {
    graphQlApiId            = aws_appsync_graphql_api.excrum.id
    dataSourceName          = local.datasource_members
    fieldName               = "listMembers"
    typeName                = "Query"
    requestMappingTemplate  = data.local_file.list_members_request_mapping.content
    responseMappingTemplate = data.local_file.list_members_response_mapping.content
  }

  template_body = data.local_file.cloudformation_resolver_template.content
}

# Create Members

data "local_file" "create_member_source_request_mapping" {
  filename = "${path.module}/scripts/api/members/create_member_request.txt"
}

data "local_file" "create_member_source_response_mapping" {
  filename = "${path.module}/scripts/api/members/create_member_response.txt"
}

resource "aws_cloudformation_stack" "create_members_resolver" {
  depends_on = [
    aws_appsync_datasource.members,
    aws_cloudformation_stack.api_schema
  ]
  name = "${local.appsync_name}-create-members-resolver"

  parameters = {
    graphQlApiId            = aws_appsync_graphql_api.excrum.id
    dataSourceName          = local.datasource_members
    fieldName               = "createMembers"
    typeName                = "Mutation"
    requestMappingTemplate  = data.local_file.create_member_source_request_mapping.content
    responseMappingTemplate = data.local_file.create_member_source_response_mapping.content
  }

  template_body = data.local_file.cloudformation_resolver_template.content
}

## List Teams

data "local_file" "list_teams_request_mapping" {
  filename = "${path.module}/scripts/api/teams/list_teams_request.txt"
}

data "local_file" "list_teams_response_mapping" {
  filename = "${path.module}/scripts/api/teams/list_teams_response.txt"
}

resource "aws_cloudformation_stack" "list_teams_resolver" {
  depends_on = [
    aws_appsync_datasource.teams,
    aws_cloudformation_stack.api_schema
  ]

  name = "${local.appsync_name}-list-teams-resolver"

  parameters = {
    graphQlApiId            = aws_appsync_graphql_api.excrum.id
    dataSourceName          = local.datasource_teams
    fieldName               = "listTeams"
    typeName                = "Query"
    requestMappingTemplate  = data.local_file.list_teams_request_mapping.content
    responseMappingTemplate = data.local_file.list_teams_response_mapping.content
  }

  template_body = data.local_file.cloudformation_resolver_template.content
}

# Create Teams

data "local_file" "create_team_source_request_mapping" {
  filename = "${path.module}/scripts/api/teams/create_team_request.txt"
}

data "local_file" "create_team_source_response_mapping" {
  filename = "${path.module}/scripts/api/teams/create_team_response.txt"
}

resource "aws_cloudformation_stack" "create_team_resolver" {
  depends_on = [
    aws_appsync_datasource.teams,
    aws_cloudformation_stack.api_schema
  ]
  name = "${local.appsync_name}-create-teams-resolver"

  parameters = {
    graphQlApiId            = aws_appsync_graphql_api.excrum.id
    dataSourceName          = local.datasource_teams
    fieldName               = "createTeams"
    typeName                = "Mutation"
    requestMappingTemplate  = data.local_file.create_team_source_request_mapping.content
    responseMappingTemplate = data.local_file.create_team_source_response_mapping.content
  }

  template_body = data.local_file.cloudformation_resolver_template.content
}

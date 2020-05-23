output "api_key" {
  value     = "${aws_appsync_api_key.excrum_api.key}"
  sensitive = true
}

output "api_uris" {
  value = "${aws_appsync_graphql_api.excrum.uris}"
}

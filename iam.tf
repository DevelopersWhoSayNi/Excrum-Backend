resource "aws_iam_role" "api" {
  name = "${local.appsync_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_to_dynamodb_policy" {
  name = "${local.appsync_name}_api_dynamodb_policy"
  role = aws_iam_role.api.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_dynamodb_table.members_dynamodb.arn}",
        "${aws_dynamodb_table.teams_dynamodb.arn}"
      ]
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
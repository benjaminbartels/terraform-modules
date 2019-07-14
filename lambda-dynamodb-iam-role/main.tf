provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
  required_version = ">= 0.12.0"
}


resource "aws_iam_role" "lambda_executor" {
  name               = "lambda_${var.app_name}_executor"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "crud_role" {
  name = "dynamodb-item-crud-role"
  role = "${aws_iam_role.lambda_executor.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:Scan",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


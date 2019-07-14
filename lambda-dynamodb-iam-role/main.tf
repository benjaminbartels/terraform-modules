provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
  required_version = ">= 0.12.0"
}

data "aws_iam_policy_document" "executor_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "crud_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:Scan",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = "${var.table_arns}"
  }
}

resource "aws_iam_role" "lambda_executor" {
  name               = "lambda_${var.app_name}_executor"
  assume_role_policy = "${data.aws_iam_policy_document.executor_policy}"
}

resource "aws_iam_role_policy" "crud_role" {
  name   = "dynamodb-item-crud-role"
  role   = "${aws_iam_role.lambda_executor.id}"
  policy = "${data.aws_iam_policy_document.crud_policy}"
}

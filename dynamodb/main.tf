provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {}
  required_version = ">= 0.12.0"
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "${var.name}"
  hash_key       = "id"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  attribute {
    name = "id"
    type = "S"
  }
}

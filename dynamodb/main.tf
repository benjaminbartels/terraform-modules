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

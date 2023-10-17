resource "aws_dynamodb_table" "my_table" {
  name           = "MyTable"
  billing_mode   = "PAY_PER_REQUEST"  # You can change this to "PROVISIONED" if needed
  hash_key       = "id"
  attribute {
    name = "id"
    type = "N"
  }
  tags = {
    Name = "MyTable"
  }
}

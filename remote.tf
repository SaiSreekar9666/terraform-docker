resource "aws_s3_bucket" "my_bucket" {
    bucket = "lms-bucket"
    tags={
        Name = "my-bucket"
    }
}
resource "aws_dynamodb_table" "terraform_lock" {
  name             = "terraform-lock"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"    # string data type
  }
}


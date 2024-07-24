resource "aws_s3_bucket" "my-bucket" {
    bucket = "lms-my-bucket"
    tags={
        Name = "my-bucket"
    }
}
#dynamodb

resource "aws_dynamodb_table" "terraform_lock" {
  name             = "terraform-lock"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"    # string data type
  }
}


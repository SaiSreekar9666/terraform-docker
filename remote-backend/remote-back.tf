terraform {
  backend "s3" {
    bucket = "lms-my-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

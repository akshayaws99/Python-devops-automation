terraform {
  backend "s3" {
    bucket  = "devops-tfstate-bucket-12345"
    key     = "terraform/statefile.tfstate"
    region  = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt = true
  }
}

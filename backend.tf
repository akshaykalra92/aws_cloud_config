terraform {
  backend "s3" {
    bucket         = "s3-tf-statefile"
    encrypt        = true
    key            = "aws_cloud_config/terraform.tfstate"
    region         = "us-east-1"
  }
}
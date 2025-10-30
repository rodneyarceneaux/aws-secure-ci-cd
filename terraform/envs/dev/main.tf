provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "secure_ci_cd_demo" {
  bucket = "rodneyarceneaux-secure-ci-cd-demo"
  tags = {
    Environment = "dev"
    Owner       = "rodneyarceneaux"
  }
}

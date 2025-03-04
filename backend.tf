terraform {
  backend "s3" {
    bucket         = "terraform-pos-lanchonete"
    key            = "lambda/state-file/terraform.tfstate"
    region         = "us-east-1"
  }
}
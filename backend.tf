terraform {
  backend "s3" {
    bucket         = "terraform-pos-lanchonete-micros"
    key            = "lambda/state-file/terraform.tfstate"
    region         = "us-east-1"
  }
}
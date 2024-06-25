terraform {
  backend "s3" {
    bucket = "381491923321-coderivy-tf-state"
    key    = "prod/iac/recsys.tfstate"
    region = "us-east-1"
    profile = "terraform"
  }
}
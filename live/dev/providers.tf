terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
  backend "s3" {
    bucket = "326347646211-us-east-2-devsecops-tf-bucket"
    key = "myapp/state.tfstate"
    region = "us-east-2"
  }
}

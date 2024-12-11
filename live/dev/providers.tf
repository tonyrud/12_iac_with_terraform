terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }

  }
  backend "s3" {
    bucket = "326347646211-us-east-2-devsecops-tf-bucket"
    key    = "dev/state.tfstate"
    region = "us-east-2"
  }
}

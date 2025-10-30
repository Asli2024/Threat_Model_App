terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.15.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags { tags = var.common_tags }
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
  default_tags { tags = var.common_tags }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
  }

  backend "http" {
    address        = "https://tf.l8n.ch/state/cld/labs"
    lock_address   = "https://tf.l8n.ch/state/cld/labs"
    unlock_address = "https://tf.l8n.ch/state/cld/labs"
    username       = "jwt"
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "eu-west-3"
}

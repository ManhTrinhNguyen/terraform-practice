provider "aws" {
  region = "us-west-1"
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list
}

variable "public_subnets" {
  type = list
}

variable "eks_name" {
  type = string
}



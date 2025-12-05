terraform {
 required_version = ">= 0.12"
 backend "s3" {
  bucket = "tf-state-list-tim"
  key = "state.tfstate"
  region = "us-west-1"
 }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.32"

  vpc_id = module.vpc.vpc_id 
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {}
  }

  tags = {
    environment = "dev"
    application = "myapp"
  }
}
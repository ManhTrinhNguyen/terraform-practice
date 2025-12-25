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

  cluster_name    = var.eks_name
  cluster_version = "1.32"

  vpc_id = module.vpc.vpc_id 
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      principal_arn = "arn:aws:iam::660753258283:user/trinhnguyen"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

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

  fargate_profiles = {
    coredns = {
    name = "coredns"
    subnet_ids = module.vpc.private_subnets
    selectors = [
    {
        namespace = "kube-system"
        labels = {
          "k8s-app" = "kube-dns" 
          }
        }
      ]
    }
    java-app = {
      name = "java-app-fargate"
      subnet_ids = module.vpc.private_subnets
      selectors = [
        {
           namespace: "my-app"
          labels = {
            app: "java-app"
          }
        }
      ]
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
pipeline {
    agent any
    stages {
        stage('Provision EKS Cluster') {
            environment {
              AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
              AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
              TF_VAR_eks_name = "eks-cluster"
            }
            steps {
                echo 'Provisioning'
                sh 'terraform init'
                sh 'terraform apply --auto-approve'
            }
        }
    }
}

// aws eks update-kubeconfig --name eks-cluster --region us-west-1


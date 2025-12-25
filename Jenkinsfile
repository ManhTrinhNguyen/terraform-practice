pipeline {
    agent any
    stages {
        stage('Provision EKS Cluster') {
            environment {
              AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
              AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            }
            steps {
                echo 'Provisioning'
                sh 'terraform init'
            }
        }
    }
}
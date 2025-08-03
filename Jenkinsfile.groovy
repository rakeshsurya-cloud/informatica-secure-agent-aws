pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-west-2'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/rakeshsurya-cloud/informatica-secure-agent-aws.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                input message: "Approve deployment?", ok: "Deploy"
                sh 'terraform apply -auto-approve'
            }
        }
    }
}

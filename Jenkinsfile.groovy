// Jenkinsfile
pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-west-2'
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/rakeshsurya-cloud/informatica-secure-agent-aws.git'
                }
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
                // The manual approval step has been removed.
                // This stage will now execute immediately after the plan is complete.
                script {
                    sh '''
                        set -x  // This provides verbose logging for debugging
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}


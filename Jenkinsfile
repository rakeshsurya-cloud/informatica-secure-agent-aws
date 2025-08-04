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
                script {
                    // Debug: Check if tfvars file exists and display content
                    sh '''
                        echo "Checking for terraform.tfvars..."
                        ls -l terraform.tfvars
                        echo "Contents of terraform.tfvars:"
                        cat terraform.tfvars
                    '''
                    // Terraform plan
                    sh 'terraform plan -var-file=terraform.tfvars'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    // Debug: Confirm tfvars file is still available
                    sh '''
                        echo "Re-checking terraform.tfvars before apply..."
                        ls -l terraform.tfvars
                        echo "Contents of terraform.tfvars:"
                        cat terraform.tfvars

                        echo "Applying Terraform with tfvars..."
                        terraform apply -auto-approve -var-file=terraform.tfvars
                    '''
                }
            }
        }
    }
}

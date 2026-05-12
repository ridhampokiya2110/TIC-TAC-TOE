pipeline {
    agent any

    environment {
        // AWS Credentials added in Jenkins
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage('Checkout 📥') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init 🛠️') {
            steps {
                dir('terraform') {
                    bat "terraform init"
                }
            }
        }

        stage('Terraform Plan 📋') {
            steps {
                dir('terraform') {
                    bat "terraform plan"
                }
            }
        }

        stage('Terraform Apply 🚀') {
            steps {
                dir('terraform') {
                    // This creates the EC2 in Stockholm automatically
                    bat "terraform apply -auto-approve"
                }
            }
        }
    }

    post {
        always {
            echo "Day 89: Cleaning up workspace..."
            cleanWs()
        }
        success {
            echo "Congratulations Ridham! Infrastructure is LIVE in Stockholm. 🌍"
        }
        failure {
            echo "Terraform failed. Check your AWS credentials or AMI ID."
        }
    }
}

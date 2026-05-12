pipeline {
    agent any

    environment {
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

        stage('Terraform Apply 🚀') {
            steps {
                dir('terraform') {
                    // Yahan -auto-approve zaroori hai
                    bat "terraform apply -auto-approve"
                }
            }
        }
    }

    post {
        success {
            echo "Day 89: Infrastructure is LIVE in us-east-1! 🚀"
        }
        failure {
            echo "Abhi bhi error hai? Console output check karo bhai."
        }
    }
}

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
                    bat "terraform apply -auto-approve"
                }
            }
        }
    }

    post {
        success {
            echo "Day 89 Success: N. Virginia Server is UP! 🚀"
        }
        failure {
            echo "Terraform failed. Check Console Logs."
        }

        always {
            echo "Pipeline Finished."
            
        }
    }
}

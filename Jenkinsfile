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
                    bat "terraform apply -auto-approve"
                }
            }
        }

        stage('Deploy App 🎮') {
            steps {
                script {
                    // 1. Fetch IP and clean the output
                    def rawIP = bat(script: "terraform -chdir=terraform output -raw instance_public_ip", returnStdout: true).trim()
                    
                    // Windows fix: Filter out extra lines and get only the IP string
                    def lines = rawIP.split('\r?\n')
                    def serverIP = lines.find { it ==~ /^[0-9.]+/ }?.trim()
                    
                    if (!serverIP) {
                        error "Bhai, IP address nahi mila! Terraform output check karo."
                    }
                    
                    echo "Target Server IP found: ${serverIP}"

                    // 2. Deployment using credentials (day-89-key)
                    withCredentials([sshUserPrivateKey(credentialsId: 'day-89-key', keyFileVariable: 'PEM_PATH')]) {
                        
                        // Server par directory banana
                        bat "ssh -i %PEM_PATH% -o StrictHostKeyChecking=no ubuntu@${serverIP} \"mkdir -p /home/ubuntu/app\""
                        
                        // Files copy karna (index.html, style.css, script.js, deploy.sh)
                        bat "scp -i %PEM_PATH% -o StrictHostKeyChecking=no index.html style.css script.js deploy.sh ubuntu@${serverIP}:/home/ubuntu/app/"
                        
                        // Execution
                        bat "ssh -i %PEM_PATH% -o StrictHostKeyChecking=no ubuntu@${serverIP} \"chmod +x /home/ubuntu/app/deploy.sh && sudo /home/ubuntu/app/deploy.sh\""
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Day 90 Success: Tic-Tac-Toe is now LIVE! 🚀"
        }
        failure {
            echo "Deployment failed. Console logs check karo."
        }
    }
}

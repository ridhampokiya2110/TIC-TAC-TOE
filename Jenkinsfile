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
                    // 1. Fetch IP
                    def rawIP = bat(script: "terraform -chdir=terraform output -raw instance_public_ip", returnStdout: true).trim()
                    def serverIP = rawIP.split('\r?\n').last().trim()
                    echo "Target Server IP found: ${serverIP}"

                    // 2. Deployment with Universal SIDs
                    withCredentials([sshUserPrivateKey(credentialsId: 'day-89-key', keyFileVariable: 'PEM_PATH')]) {
                        
                        // Universal Windows Permissions Fix using SIDs
                        bat """
                            icacls "%PEM_PATH%" /inheritance:r
                            icacls "%PEM_PATH%" /grant:r *S-1-5-18:(R)
                            icacls "%PEM_PATH%" /grant:r *S-1-5-32-544:(R)
                        """

                        // Execute deployment commands
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"mkdir -p /home/ubuntu/app\""
                        bat "scp -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no index.html style.css script.js deploy.sh ubuntu@${serverIP}:/home/ubuntu/app/"
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"chmod +x /home/ubuntu/app/deploy.sh && sudo /home/ubuntu/app/deploy.sh\""
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

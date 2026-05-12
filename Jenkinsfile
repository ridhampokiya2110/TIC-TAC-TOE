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

                    // 2. Deployment with STRICT permissions
                    withCredentials([sshUserPrivateKey(credentialsId: 'day-89-key', keyFileVariable: 'PEM_PATH')]) {
                        
                        bat """
                            :: 1. Inheritance disable karo (saari purani permissions hatao)
                            icacls "%PEM_PATH%" /inheritance:r /t
                            
                            :: 2. Sirf current user ko Read permission do
                            icacls "%PEM_PATH%" /grant:r "%USERNAME%":"(R)"
                            
                            :: 3. Verify karne ke liye (Optional: Console me dikhega)
                            icacls "%PEM_PATH%"
                        """

                        // Ab SSH command bypass karega permissions check
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

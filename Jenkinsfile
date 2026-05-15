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

        stage('Deploy App via Docker Hub 🐳☁️') {
            steps {
                script {
                    // Fetch dynamic IP from Terraform
                    def rawIP = bat(script: "terraform -chdir=terraform output -raw instance_public_ip", returnStdout: true).trim()
                    def serverIP = rawIP.split('\r?\n').last().trim()
                    echo "Target Server IP found: ${serverIP}"

                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'day-89-key', keyFileVariable: 'PEM_PATH'),
                        usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')
                    ]) {
                        
                        // Windows Strict Permissions Fix
                        bat """
                            icacls "%PEM_PATH%" /inheritance:r
                            icacls "%PEM_PATH%" /grant:r *S-1-5-18:(R)
                            icacls "%PEM_PATH%" /grant:r *S-1-5-32-544:(R)
                        """

                        // 1. Create App Directory & Copy Files
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"mkdir -p /home/ubuntu/app\""
                        bat "scp -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no index.html style.css script.js Dockerfile ubuntu@${serverIP}:/home/ubuntu/app/"
                        
                        // 🔥 THE FIX: Wait for EC2 to finish installing Docker (cloud-init wait)
                        echo "Waiting for EC2 to finish background installations..."
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"cloud-init status --wait\""

                        // 2. DOCKER HUB MAGIC: Login, Build & Push! 
                        // (Changed ${VAR} to %VAR% to fix Jenkins Security Warning)
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"sudo docker login -u %DOCKER_USER% -p %DOCKER_PASS% && cd /home/ubuntu/app && sudo docker build -t %DOCKER_USER%/tic-tac-toe-app:latest . && sudo docker push %DOCKER_USER%/tic-tac-toe-app:latest\""
                        
                        // 3. RUN: Stop old container and Run the newly pulled image
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"sudo docker stop game-container || true && sudo docker rm game-container || true && sudo docker run -d --name game-container -p 80:80 %DOCKER_USER%/tic-tac-toe-app:latest\""
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

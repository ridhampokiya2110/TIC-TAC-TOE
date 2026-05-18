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

                        // 1. Create App Directory & Copy Files (Added -r for the k8s folder)
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"mkdir -p /home/ubuntu/app\""
                        bat "scp -r -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no index.html style.css script.js Dockerfile k8s ubuntu@${serverIP}:/home/ubuntu/app/"
                        
                        // Wait for EC2 installations (Docker, Trivy, K3s)
                        echo "Waiting for EC2 to finish background installations..."
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"cloud-init status --wait\""

                        // 2. Build, Scan & Push Image
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"sudo docker login -u %DOCKER_USER% -p %DOCKER_PASS% && cd /home/ubuntu/app && sudo docker build -t %DOCKER_USER%/tic-tac-toe-app:latest . && echo 'Starting Trivy Vulnerability Scan...' && sudo trivy image --severity HIGH,CRITICAL %DOCKER_USER%/tic-tac-toe-app:latest && sudo docker push %DOCKER_USER%/tic-tac-toe-app:latest\""
                        
                        // 3. 🔥 KUBERNETES DEPLOYMENT MAGIC! 
                        // Sed command injects your exact Docker Hub username into the deployment.yaml, then applies it.
                        bat "ssh -i \"%PEM_PATH%\" -o StrictHostKeyChecking=no ubuntu@${serverIP} \"cd /home/ubuntu/app && sed -i 's/DOCKER_USER_PLACEHOLDER/%DOCKER_USER%/g' k8s/deployment.yaml && sudo k3s kubectl apply -f k8s/\""
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

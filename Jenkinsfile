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
                    // 1. Terraform output se Public IP lena
                    def serverIP = bat(script: "terraform -chdir=terraform output -raw instance_public_ip", returnStdout: true).trim()
                    echo "Deploying Tic-Tac-Toe to: ${serverIP}"

                    // 2. SSH Agent ke through deployment (using your day-89-key)
                    // Windows Jenkins ke liye hum 'withCredentials' use karenge jo %PEM_PATH% create karega
                    withCredentials([sshUserPrivateKey(credentialsId: 'day-89-key', keyFileVariable: 'PEM_PATH')]) {
                        
                        // Workspace ki files server par bhejna (excluding .git and terraform folders)
                        // Pehle server par directory banate hain
                        bat "ssh -i %PEM_PATH% -o StrictHostKeyChecking=no ubuntu@${serverIP} \"mkdir -p /home/ubuntu/app\""
                        
                        // Files copy karna
                        bat "scp -i %PEM_PATH% -o StrictHostKeyChecking=no -r index.html style.css script.js deploy.sh ubuntu@${serverIP}:/home/ubuntu/app/"
                        
                        // Deploy script execute karna
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

pipeline {
    agent any
    
    environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
        IMAGE_NAME = "ridhampokiya/day87-app" 
        // Niche apna EC2 ka Public IP daalo
        EC2_IP = "32.197.122.63" 
        EC2_USER = "ubuntu"
    }

    stages {
        stage('Checkout..') {
            steps { checkout scm }
        }
        
        stage('Build Image..') {
            steps {
                bat "docker build -t ${IMAGE_NAME}:${env.BUILD_ID} ."
                bat "docker build -t ${IMAGE_NAME}:latest ."
            }
        }
        
        stage('Push to Docker Hub..') {
            steps {
                bat "echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin"
                bat "docker push ${IMAGE_NAME}:${env.BUILD_ID}"
                bat "docker push ${IMAGE_NAME}:latest"
            }
        }
        stage('Deploy to EC2..!') {
    steps {
        echo "Tic-Tac-Toe Deployment: Final Permission Overhaul..."
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-key', keyFileVariable: 'PEM_FILE')]) {
            bat """
            @echo off
            :: 1. Is temporary file ki sari purani permissions ko jad se khatam karo
            powershell -Command "icacls '%PEM_FILE%' /inheritance:r /grant:r 'SYSTEM:F' /grant:r 'Administrators:F' /grant:r '%USERNAME%:F'"
            
            :: 2. Check karne ke liye ki permissions set hui ya nahi (Logs me dikhega)
            icacls "%PEM_FILE%"
            
            :: 3. Ab SSH chalao, lekin -q (quiet) mode me taaki faltu warnings na aaye
            ssh -i "%PEM_FILE%" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q ${EC2_USER}@${EC2_IP} "sudo docker pull ${IMAGE_NAME}:latest && sudo docker stop live-app || exit 0 && sudo docker rm live-app || exit 0 && sudo docker run -d --name live-app -p 80:80 ${IMAGE_NAME}:latest"
            """
                }
            }
        }
    }
}

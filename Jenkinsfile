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
        stage('Deploy to EC2..!!') {
    steps {
        echo "Direct Deployment via Batch..."
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-key', keyFileVariable: 'PEM_FILE')]) {
        
            bat 'ssh -o StrictHostKeyChecking=no -i %PEM_FILE% ' + "${EC2_USER}@${EC2_IP}" + ' "sudo docker pull ${IMAGE_NAME}:latest && sudo docker stop live-app || exit 0 && sudo docker rm live-app || exit 0 && sudo docker run -d --name live-app -p 80:80 ${IMAGE_NAME}:latest"'
                }
            }
        }
    }
}

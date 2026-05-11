pipeline {
    agent any
    
    environment {
        // Fetching secrets from Jenkins Vault
        DOCKER_CREDS = credentials('dockerhub-creds')
        // Dhyan se niche apna Docker Hub ka username daalna
        IMAGE_NAME = "ridhampokiya/day87-app" 
    }

    stages {
        stage('Checkout..') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Image..') {
            steps {
                echo "Building Docker Image version: ${env.BUILD_ID}"
                // Windows ke liye bat use kar rahe hain
                bat "docker build -t ${IMAGE_NAME}:${env.BUILD_ID} ."
                bat "docker build -t ${IMAGE_NAME}:latest ."
            }
        }
        
        stage('Push to Docker Hub..!!!') {
            steps {
                echo "Logging into Docker Hub securely..."
                // Secret password ko pipeline print nahi karegi (hide kar degi)
                bat "echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin"
                
                echo "Pushing Image..."
                bat "docker push ${IMAGE_NAME}:${env.BUILD_ID}"
                bat "docker push ${IMAGE_NAME}:latest"
            }
        }
    }
}

pipeline {
    agent any
    
    environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
        IMAGE_NAME = "ridhampokiya/day87-app" 

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
        pipeline {
    agent any
    // ... (baaki purana code) ...

    post {
        always {
            echo "Pipeline finished. Cleaning up workspace..."
            cleanWs() // Workspace saaf kar deta hai taaki memory full na ho
        }
        success {
            echo "Mubarak ho! Deployment Success."
            // Yahan mail bhej sakte ho
            emailext body: "Bhai, Day 88 success ho gaya! Build # ${env.BUILD_NUMBER} live hai.",
                     subject: "Jenkins Success: ${env.JOB_NAME}",
                     to: "tumhara-email@gmail.com"
        }
        failure {
            echo "Dhat teri ki! Pipeline fail ho gayi."
            emailext body: "Bhai, pipeline fail ho gayi hai. Check kar kya lafda hua.",
                     subject: "Jenkins Failure: ${env.JOB_NAME}",
                     to: "tumhara-email@gmail.com"
                }
            }
        }
        
    }
}

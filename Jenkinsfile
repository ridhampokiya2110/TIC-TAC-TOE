pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
        IMAGE_NAME = "ridhampokiya/day87-app"
    }

    stages {
        stage('Checkout 📥') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push 🚀') {
            steps {
                // Windows par ho isliye 'bat' use kar rahe hain
                bat "docker build -t ${IMAGE_NAME}:latest ."
                bat "echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin"
                bat "docker push ${IMAGE_NAME}:latest"
            }
        }
        
        stage('Health Check 🩺') {
            steps {
                echo "Checking Pipeline Health..."
                bat "docker images"
            }
        }
    }

    // Post section stages ke BAHAR hota hai, par pipeline ke ANDAR
    post {
        always {
            echo "Day 88: Cleaning up Workspace..."
            cleanWs() 
        }
        success {
            echo "Mubarak ho Ridham! Day 88 Success."
            // Agar Email setup hai toh ye chalega, warna sirf log dikhayega
            echo "Notification: Build #${env.BUILD_NUMBER} is successful!"
        }
        failure {
            echo "Lafda ho gaya! Check the logs."
        }
    }
}

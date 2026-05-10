pipeline {
    agent any

    stages {
        stage('Build..') {
            steps {
                echo 'Building the application layers...'
                // Yahan actual docker build command aati hai
            }
        }
        stage('Test..') {
            steps {
                echo 'Running security and unit tests...'
                // Yahan testing scripts aati hain
            }
        }
        stage('Deploy..!') {
            steps {
                echo 'Deploying application to production server...'
                // Yahan ECR push ya EC2 run command aati hai
            }
        }
    }
}

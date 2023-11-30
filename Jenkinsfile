pipeline {
    agent any
	
	environment {
        registryCredential = 'AWS_ECR'
        registry = '061828348490.dkr.ecr.ap-northeast-2.amazonaws.com'
        app = 'gopang'
        region = 'ap-northeast-2'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                        credentialsId: 'gopang-github-up',
                        url: 'https://github.com/ProjectGopang/conn_test.git'
            }
        }

        stage('Prepare Workspace') {
            steps {
                script {
                    // Gradle Wrapper execution permission
                    sh 'chmod +x gradlew'
                }
            }
        }

        stage('Gradle Build') {
            steps {
                script {
                    // Run Gradle build
                    sh './gradlew clean build'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build Docker image
                    docker.build("${registry}/${app}:${BUILD_NUMBER}", '.')

                    // Log in to ECR
                    withCredentials([usernamePassword(credentialsId: registryCredential, passwordVariable: 'AWS_PASSWORD', usernameVariable: 'AWS_USERNAME')]) {
                        docker.withRegistry("https://${registry}", "ecr:${region}") {
                            // Push Docker image to ECR
                            docker.image("${registry}/${app}:${BUILD_NUMBER}").push()
                        }
                    }
                }
            }
        }
    }
}

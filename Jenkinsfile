pipeline {
    agent any
	
    environment {
        registry = '061828348490.dkr.ecr.ap-northeast-2.amazonaws.com/gopang' // 개발 AWS에 생성한 컨슈머용 ECR 주소
        registryCredential = 'AWS_ECR' // Jenkins에 설정한 AWS용 Credential ID
    }
	
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                        credentialsId: 'gopang',
                        url: 'https://github.com/JavaBrewer/geo-test1.git'
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
                    docker.build("${registry}:${BUILD_NUMBER}", '.')

                    // Log in to ECR
                    withCredentials([usernamePassword(credentialsId: registryCredential, passwordVariable: 'AWS_PASSWORD', usernameVariable: 'AWS_USERNAME')]) {
                        docker.withRegistry("https://${registry}", 'ecr:ap-northeast-2') {
                            // Push Docker image to ECR
                            docker.image("${registry}:${BUILD_NUMBER}").push()
                        }
                    }
                }
            }
        }
    }
}

pipeline {
    agent any
    environment {
        registry = "061828348490.dkr.ecr.ap-northeast-2.amazonaws.com/gopang"
        registryCredential = "dev3"
        app = ''
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

        // Building Docker images
        stage('Docker Build') {
            steps {
                script {
                    app = docker.build("search/sentry-kafka-consumer:${version}", "--build-arg ENVIRONMENT=${env} .")   // Docker Build를 하는데 나의 경우 version을 Jenkins 매개변수로 입력 받게 셋팅하였다. Jenkins 매개변수는 ${변수명} 이렇게 사용 가능하다
                }
            }
        }

        // Uploading Docker images into AWS ECR
        stage('Push Image') {
            steps {
                script{
 
                    docker.withRegistry("https://" + registry, "ecr:ap-northeast-2:" + registryCredential) {   // withRegistry(이미지 올릴 ECR 주소, Credentail ID) 이렇게 셋팅하면 된다.
                        app.push("${version}")   // tag 정보
                        app.push("latest")       // tag 정보
                    }
                }
            }
        }
    }
}

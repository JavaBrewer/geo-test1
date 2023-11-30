pipeline {
    agent any
    
    environment {
        CONTAINER_NAME = 'gopang-test-container'
        AWS_CREDENTIAL_NAME = 'dev3'
        ECR_PATH = '061828348490.dkr.ecr.ap-northeast-2.amazonaws.com'
        IMAGE_NAME = '61828348490.dkr.ecr.ap-northeast-2.amazonaws.com/gopang'
        REGION = 'ap-northeast-2'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                        credentialsId: 'jog_ps',
                        url: 'https://github.com/JavaBrewer/geo-test1.git'
            }
        }

        stage('Build Gradle') {
            steps {
                echo 'Build Gradle'
                try {
                    dir('.') {
                        sh '''
                            pwd
                            cd /var/jenkins_home/workspace/teamPlannerBackEnd_jenkinsFile
                            chmod +x ./gradlew
                            ./gradlew build --exclude-task test
                        '''
                    }
                } catch (Exception e) {
                    currentBuild.result = 'FAILURE'
                    error("Failed to build Gradle: ${e.message}")
                }
            }
        }

        // Building Docker images
        stage('Push Docker') {
            steps {
                echo 'Push Docker'
                try {
                    script {
                        // cleanup current user docker credentials
                        sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'
                        
                        docker.withRegistry("https://${ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_NAME}") {
                            docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push()
                            docker.image("${IMAGE_NAME}:latest").push()
                        }
                    }
                } catch (Exception e) {
                    currentBuild.result = 'FAILURE'
                    error("Failed to push Docker image: ${e.message}")
                }
            }
        }
    }

    

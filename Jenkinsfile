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

				dir('.'){
					sh '''
						pwd
						cd /var/jenkins_home/workspace/teamPlannerBackEnd_jenkinsFile
						chmod +x ./gradlew
						./gradlew build --exclude-task test
					'''
				}
			}
			post {
				failure {
					error 'This pipeline stops here...'
				}
			}
		}
		
		stage('Build Docker') {
            steps {
                echo 'Build Docker'
                sh """
                    cd /var/jenkins_home/workspace/teamPlannerBackEnd_jenkinsFile
                    docker builder prune
                    docker build -t $IMAGE_NAME:$BUILD_NUMBER .
                    docker tag $IMAGE_NAME:$BUILD_NUMBER $IMAGE_NAME:latest
                """
            }
            post {
                failure {
                    error 'This pipeline stops here...'
                }
            }
        }
		
        stage('Clean Up Docker Images on Jenkins Server') {
			steps {
				echo 'Cleaning up unused Docker images on Jenkins server'

				// Clean up unused Docker images, including those created within the last hour
				sh "docker image prune -f --all --filter \"until=1h\""
			}
		}
}

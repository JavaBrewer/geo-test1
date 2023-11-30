pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="061828348490"
        AWS_DEFAULT_REGION="ap-northeast-2"
        IMAGE_REPO_NAME="jenkins-pipeline"
        IMAGE_TAG="v1"
	registryCredential = 'dev3'
        REPOSITORY_URI = "061828348490.dkr.ecr.ap-northeast-2.amazonaws.com/gopang"
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
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh """docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"""
                sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"""
         }
        }
      }
    }
}

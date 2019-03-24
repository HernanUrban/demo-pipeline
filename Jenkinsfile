pipeline {
    agent { label 'ecs-java' }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'chmod +x ./mvnw'
                sh './mvnw clean package'
            }
        }
        stage('Test') {
            steps {
                sh './mvnw verify'
            }
        }
        stage('Publish') {
	        when {
	            expression { BRANCH_NAME ==~ /(develop)/ }
	        }
            steps {
                echo 'publish artifacts to Nexus'
            }
        }
        stage('Dockerize') {
	        when {
	            expression { BRANCH_NAME ==~ /(develop)/ }
	        }
            steps {
              script {
                docker.build('hurban/demo-pipeline')
              }
            }
        }
        stage('Push') {
	        when {
	            expression { BRANCH_NAME ==~ /(develop)/ }
	        }
            steps {
              script {
                docker.withRegistry('https://321208450064.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:AWS-ECR-Publisher') {
                  docker.image('hurban/demo-pipeline').push('latest')
                }
		      }
			}
        }
        stage('Deploy') {
            when {
                branch 'develop'
            }
            steps {
                echo 'Deploy to ECS'
                script {
                    withAWS(region:'us-east-1',credentials:'AWS-ECR-Publisher') {
                       sh 'aws ecs update-service --cluster pipe-dev --service App-pipe-AR-dev --task-definition App-pipe-AR-dev --force-new-deployment'
                    }
                }
            }
        }
  }
  post {
    always{
          echo 'Run some clean steps and test reports'
          junit "target/surefire-reports/*.xml"
    }
  }
}

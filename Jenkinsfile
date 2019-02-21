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
                sh './mvnw clean package -DskipTests'
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
              echo 'push to Image into repository/registry'
              script {
                docker.withRegistry('https://321208450064.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:AWS-ECR-Publisher') {
                  docker.image('hurban/demo-pipeline').push('latest')            
                }
		      }
			}
        }
        stage('Deploy') {
	        when {
	            expression { BRANCH_NAME ==~ /(develop)/ }
	        }
            steps {
                echo 'deployment tasks'
            }
        }
    stage('Validate') {
	  when {
	        expression { BRANCH_NAME ==~ /(develop)/ }
	  }
	  steps{
			echo 'Validatie application status through healthchecks'
        	//script {
            //	timeout(time: 60, unit: 'SECONDS') {
            //    	waitUntil {
            //        	sleep 5
            //        	def r = sh script: "wget -q http://<host>:<port>/actuator/info -O /dev/null", returnStatus: true
            //        	return r == 0
            //    	}
            //    }
        	//}
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

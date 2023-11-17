pipeline {
    agent any
    environment {
        GIT_REPO_URL = 'https://github.com/Hatem902/docker-tp'
    }
    stages{
        stage('Fetch from GitHub') {
            steps {
                echo "******** FETCHING ********"
                checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: GIT_REPO_URL]]])
            }
        }

        stage('Build Docker Images'){
            steps{
                echo "******** BUILDING ********"
                bat 'docker build -f ./api/Dockerfile -t vicyyn/docker-tp-api:%BUILD_NUMBER% .'
		        bat 'docker build -f ./myblog/Dockerfile -t vicyyn/docker-tp-myblog:%BUILD_NUMBER% .'
            }
        }

        stage('Test Run Containers'){
            steps{
                echo "******** TESTING ********"
                bat 'docker run -d --name test-api vicyyn/docker-tp-api:%BUILD_NUMBER%'
		        bat 'docker run -d --name test-myblog vicyyn/docker-tp-myblog:%BUILD_NUMBER%'
            }
        }

        stage('Push to Docker Hub'){
            steps{
                echo "******** PUSHING ********"
                withCredentials([usernamePassword(
                    credentialsId: 'docker_hub_credentials',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD')
                ]) {
                    bat 'docker login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%'
                }
                bat 'docker push vicyyn/docker-tp-api:%BUILD_NUMBER%'
                bat 'docker push vicyyn/docker-tp-myblog:%BUILD_NUMBER%'
            }
        }

        stage('Clean Environment'){
            steps{
                echo "******** CLEANING ********"
                bat 'docker stop test-api'
                bat 'docker stop test-myblog'
                bat 'docker rm test-api'
                bat 'docker rm test-myblog'
                bat 'docker rmi vicyyn/docker-tp-api:%BUILD_NUMBER%'
                bat 'docker rmi vicyyn/docker-tp-myblog:%BUILD_NUMBER%'
            }
        }
    }
}

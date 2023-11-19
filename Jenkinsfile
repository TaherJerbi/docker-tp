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
                sh 'docker build -f ./api/Dockerfile -t taherjerbiinsat/docker-tp-api:%BUILD_NUMBER% .'
		        sh 'docker build -f ./myblog/Dockerfile -t taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER% .'
            }
        }

        stage('Test Run Containers'){
            steps{
                echo "******** TESTING ********"
                sh 'docker run -d --name test-api taherjerbiinsat/docker-tp-api:%BUILD_NUMBER%'
		        sh 'docker run -d --name test-myblog taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER%'
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
                    sh 'docker login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%'
                }
                sh 'docker push taherjerbiinsat/docker-tp-api:%BUILD_NUMBER%'
                sh 'docker push taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER%'
            }
        }

        stage('Clean Environment'){
            steps{
                echo "******** CLEANING ********"
                sh 'docker stop test-api'
                sh 'docker stop test-myblog'
                sh 'docker rm test-api'
                sh 'docker rm test-myblog'
                sh 'docker rmi taherjerbiinsat/docker-tp-api:%BUILD_NUMBER%'
                sh 'docker rmi taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER%'
            }
        }
    }
}

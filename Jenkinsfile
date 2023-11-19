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
                bash 'docker build -f ./api/Dockerfile -t taherjerbiinsat/docker-tp-api:%BUILD_NUMBER% .'
		        bash 'docker build -f ./myblog/Dockerfile -t taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER% .'
            }
        }

        stage('Test Run Containers'){
            steps{
                echo "******** TESTING ********"
                bash 'docker run -d --name test-api taherjerbiinsat/docker-tp-api:%BUILD_NUMBER%'
		        bash 'docker run -d --name test-myblog taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER%'
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
                    bash 'docker login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%'
                }
                bash 'docker push taherjerbiinsat/docker-tp-api:%BUILD_NUMBER%'
                bash 'docker push taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER%'
            }
        }

        stage('Clean Environment'){
            steps{
                echo "******** CLEANING ********"
                bash 'docker stop test-api'
                bash 'docker stop test-myblog'
                bash 'docker rm test-api'
                bash 'docker rm test-myblog'
                bash 'docker rmi taherjerbiinsat/docker-tp-api:%BUILD_NUMBER%'
                bash 'docker rmi taherjerbiinsat/docker-tp-myblog:%BUILD_NUMBER%'
            }
        }
    }
}

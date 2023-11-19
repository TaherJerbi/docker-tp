pipeline {
    agent any
    environment {
        GIT_REPO_URL = 'https://github.com/Hatem902/docker-tp'
    }
    stages {
        stage('Fetch from GitHub') {
            steps {
                echo "******** FETCHING ********"
                checkout([$class: 'GitSCM', branches: [[name: '*/jenkins']],
                    userRemoteConfigs: [[url: GIT_REPO_URL]]])
            }
        }

        stage('Build Docker Images'){
            steps{
                echo "******** BUILDING ********"
                def apiImage = docker.build("taherjerbiinsat/docker-tp-api:${env.BUILD_NUMBER}", './api/Dockerfile')
		        def myblogImage = docker.build("taherjerbiinsat/docker-tp-myblog:${env.BUILD_NUMBER}", './myblog/Dockerfile')
            }
        }

        stage('Push to Docker Hub'){
            steps{
                echo "******** PUSHING ********"
                docker.withRegistry('', 'docker_hub_credentials') {
                    apiImage.push()
                    myblogImage.push()
                }
            }
        }
    }
}


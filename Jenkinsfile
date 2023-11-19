pipeline {
    agent any
    environment {
        GIT_REPO_URL = 'https://github.com/Hatem902/docker-tp'
    }
    stages {
        stage('Fetch from GitHub') {
            steps {
                echo "******** FETCHING ********"
                git branch: 'jenkins', url: GIT_REPO_URL
            }
        }

        stage('Build Docker Images') {
            steps {
                echo "******** BUILDING ********"
                script {
                    def apiImage = docker.build("taherjerbiinsat/docker-tp-api:${env.BUILD_NUMBER}", './api')
                    def myblogImage = docker.build("taherjerbiinsat/docker-tp-myblog:${env.BUILD_NUMBER}", './myblog')
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "******** PUSHING ********"
                script {
                    docker.withRegistry('', 'docker_hub_credentials') {
                        apiImage.push()
                        myblogImage.push()
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
    }
}


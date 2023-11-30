pipeline {
    agent any
    tools {nodejs "node"}
    environment {
        GIT_REPO_URL = 'https://github.com/TaherJerbi/docker-tp'
    }
    stages {
        stage('Fetch from GitHub') {
            steps {
                echo "******** FETCHING ********"
                git branch: 'jenkins', url: GIT_REPO_URL
            }
        }

        stage('Test API') {
            steps {
                script {
                    echo "******** TESTING API ********"
                    dir('api') {
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }

        stage('Build and Push Docker Images') {
            steps {
                script {
                    echo "******** BUILDING ********"
                    def apiImage = docker.build("taherjerbiinsat/docker-tp-api:${env.BUILD_NUMBER}", './api')
                    def myblogImage = docker.build("taherjerbiinsat/docker-tp-myblog:${env.BUILD_NUMBER}", './myblog')
                    echo "******** PUSHING ********"
                    docker.withRegistry('', 'docker_hub_credentials') {
                        apiImage.push()
                        myblogImage.push()
                    }
                }
            }
        }

        stage('Déploiement de l’Infrastructure IaC') {
            steps {
                sh 'terraform init && terraform apply -auto-approve -var "docker_image_tag" ${env.BUIL_NUMBER}'
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


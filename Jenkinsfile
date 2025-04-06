pipeline {
    agent any

    environment {
        DOCKER_IMAGE_DEV = "mydockerhub/myapp-dev"
        DOCKER_IMAGE_STAGE = "mydockerhub/myapp-stage"
        DOCKER_IMAGE_PROD = "mydockerhub/myapp-prod"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies & Test') {
            steps {
                sh '''
                    pip install -r requirements.txt
                    pytest tests/
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    def branch = env.BRANCH_NAME
                    def image = ""
                    if (branch == 'dev') {
                        image = "${DOCKER_IMAGE_DEV}:${env.BUILD_NUMBER}"
                    } else if (branch == 'stage') {
                        image = "${DOCKER_IMAGE_STAGE}:${env.BUILD_NUMBER}"
                    } else if (branch == 'main') {
                        image = "${DOCKER_IMAGE_PROD}:${env.BUILD_NUMBER}"
                    } else {
                        error("Branch not supported for deployment")
                    }

                    docker.build(image)

                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${image}
                        """
                    }
                }
            }
        }

        stage('Deploy to Prod') {
            when {
                branch 'main'
            }
            steps {
                echo "Deploying production image..."
                // Add SSH, K8s or Docker remote deploy script here
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

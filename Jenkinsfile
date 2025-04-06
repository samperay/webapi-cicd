pipeline {
    agent any

    environment {
        DOCKER_IMAGE_DEV = "sunlnx/fastapi-dev"
        DOCKER_IMAGE_STAGE = "sunlnx/fastapi-stage"
        DOCKER_IMAGE_PROD = "sunlnx/fastapi-prod"
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
                    python3 -m venv .venv
                    source .venv/bin/activate
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
                    } else if (branch == 'master') {
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

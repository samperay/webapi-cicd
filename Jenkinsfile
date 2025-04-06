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
                    . .venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    PYTHONPATH=. pytest tests/
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
        // stage('Deploy to Prod') {
        //     when {
        //         branch 'main'
        //     }
        //     steps {
        //         echo "Deploying production image..."
        //         // Add SSH, K8s or Docker remote deploy script here
        //     }
        // }


// stage('Deploy to Prod') {
//     when {
//         branch 'main'
//     }
//     steps {
//         script {
//             def imageName = "myapp:latest"

//             echo "Deploying production image locally..."

//             // Stop and remove any existing container
//             sh """
//                 docker rm -f myapp-container || true
//             """

//             // Run the Docker container
//             sh """
//                 docker run -d --name myapp-container -p 8080:80 ${imageName}
//             """

//             // Check if it's running
//             sh """
//                 echo "Checking if container is up..."
//                 docker ps | grep myapp-container
//             """

//             echo "App should now be accessible at: http://localhost:8080"
//         }
//     }
// }

stage('check on dev environment') {
    when {
        branch 'dev'
    }
    steps {
        script {
            def imageName = "myapp:latest"

            echo "Deploying production image locally..."

            // Stop and remove any existing container
            sh """
                docker rm -f myapp-container || true
            """

            // Run the Docker container
            sh """
                docker run -d --name myapp-container -p 8080:80 ${imageName}
            """

            // Check if it's running
            sh """
                echo "Checking if container is up..."
                docker ps | grep myapp-container
            """

            echo "App should now be accessible at: http://localhost:8080"
        }
    }
}


    }

    post {
        always {
            cleanWs()
        }
    }
}

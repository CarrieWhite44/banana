pipeline {

    agent any

    environment {
        IMAGE_NAME = "tprff2301/banana-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Build') {
            steps {
                sh '''
                docker build \
                    -t $IMAGE_NAME:$IMAGE_TAG \
                    .
                '''
            }
        }

        stage('Push') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'banana',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {

                    sh '''
                    echo $DOCKER_PASS | docker login \
                        -u $DOCKER_USER \
                        --password-stdin

                    docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy') {

            steps {

                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {

                    sh '''
                    kubectl set image deployment/banana-app \
                      banana-app=$IMAGE_NAME:$IMAGE_TAG

                    kubectl rollout status deployment/banana-app
                    '''
                }
            }
        }
    }
}
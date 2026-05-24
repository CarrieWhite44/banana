pipeline {
    agent any

    environment {
        IMAGE_NAME = "tprff2301/banana-app"
    }

    stages {

        stage('Build') {
            steps {
                sh 'docker build -t $banana-app:latest .'
            }
        }

        stage('Push') {
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $banana-app:latest
                    '''
                }
            }
        }
    }
}
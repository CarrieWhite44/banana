pipeline {

    agent any

    environment {
        IMAGE_NAME = "tprff2301/banana-app"
        EC2_IP = "13.63.154.146"
        EC2_USER = "ubuntu"
    }

    stages {

        stage('Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'banana',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ubuntu']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                    docker compose pull

                    docker compose down

                    docker compose up -d
                    '
                    """
                }
            }
        }
    }
}
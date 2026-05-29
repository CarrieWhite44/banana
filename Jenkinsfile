pipeline {

    agent any

    environment {
        IMAGE_NAME = "tprff2301/banana-app"
        EC2_IP = "13.62.19.59"
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
                sshagent(['banana']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                        docker pull tprff2301/banana-app:latest

                        docker stop app || true
                        docker rm app || true

                        docker run -d --name app -p 8080:5000 tprff2301/banana-app:latest
                    '
                    """
                }
            }
        }
    }
}
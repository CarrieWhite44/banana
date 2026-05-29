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

                sshagent(['ec2-ssh']) {

                    sh '''
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP "

                    cd banana-app &&

                    docker compose pull &&

                    docker compose up -d
                    "
                    '''
                }
            }
        }
    }
}
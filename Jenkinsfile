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
                sh """
                eval \"\$(ssh-agent -s)\"
                ssh-add /var/jenkins_home/.ssh/banana.pem

                ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} << 'EOF'
                    docker pull ${IMAGE_NAME}:latest
                    docker stop app || true
                    docker rm app || true
                    docker run -d -p 80:5000 ${IMAGE_NAME}:latest
                EOF
                """
            }
        }
    }
}
pipeline {
    agent any

    environment {
        IMAGE_NAME = "tprff2301/banana-app"
        EC2_IP = "16.170.250.135"
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

        stage('Deploy') {
            steps {
                sshagent(credentials: ['banana']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP << 'EOF'

                    docker pull $IMAGE_NAME:latest

                    docker stop myapp || true
                    docker rm myapp || true

                    docker run -d --name myapp -p 8000:8000 $IMAGE_NAME:latest

                    EOF
                    """
                }
            }
        }

    }
}
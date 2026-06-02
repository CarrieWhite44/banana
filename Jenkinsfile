pipeline {

    agent any

    environment {
        IMAGE_NAME = "tprff2301/banana-app"
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
stage('Get IP') {
    steps {
        // Убедитесь, что у вас в Jenkins добавлены Credentials типа "Secret text" 
        // с ID 'aws-access-key' и 'aws-secret-key'
        withCredentials([
            string(credentialsId: 'ec2-ssh', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'ec2-ssh', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            script {
                env.EC2_IP = sh(
                    script: '''
                    cd terraform
                    
                    # Задаем дефолтный регион для AWS провайдера внутри контейнера
                    export AWS_DEFAULT_REGION="eu-north-1"
                    
                    # 1. Инициализируем Terraform (он автоматически скачает state из S3)
                    terraform init -input=false -no-color
                    
                    # 2. Получаем IP-адрес напрямую из облачного состояния
                    terraform output -raw ec2_ip
                    ''',
                    returnStdout: true
                ).trim()
            }
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
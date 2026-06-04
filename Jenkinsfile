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
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'banana-aws-key']
                ]) {

                    sh '''
                        cd terraform
                        export AWS_DEFAULT_REGION=eu-north-1
                        terraform init -input=false -no-color
                    '''

                    script {
                        env.EC2_IP = sh(
                            script: '''
                                cd terraform
                                terraform output -raw ec2_ip
                            ''',
                            returnStdout: true
                        ).trim()

                        echo "IP FOUND: ${env.EC2_IP}"
                    }
                }
            }
        }
        stage('Create Inventory') {
        steps {
            writeFile file: 'ansible/inventory', text: """
        [web]
        ${EC2_IP} ansible_user=ubuntu
        """
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sshagent(['ubuntu']) {
                    sh '''
                    export ANSIBLE_HOST_KEY_CHECKING=False

                    ansible-playbook \
                        -i ansible/inventory \
                        ansible/deploy.yml
                    '''
                }
            }
        }

    }
}
pipeline {
    agent any

    environment {
        IMAGE_NAME = "financeme-app"
        DOCKERHUB_USER = "sarafabhinav1997"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/abhinav-saraf/star-agile-banking-finance.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker tag $IMAGE_NAME $DOCKERHUB_USER/$IMAGE_NAME:latest'
                    sh 'docker push $DOCKERHUB_USER/$IMAGE_NAME:latest'
                }
            }
        }

        stage('Provision Test Infra') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'aws_ssh_key', keyFileVariable: 'KEY_FILE')]) {
                    dir('terraform/test') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve -var="key_path=$KEY_FILE"'
                    }
                }
            }
        }

        stage('Configure Test Server') {
            steps {
                sh 'ansible-playbook -i ansible/inventory/test ansible/playbooks/deploy.yml'
            }
        }

        stage('Manual Approval for Prod?') {
            steps {
                input message: 'Promote to production?'
            }
        }

        stage('Provision & Deploy to Prod') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'aws_ssh_key', keyFileVariable: 'KEY_FILE')]) {
                    dir('terraform/prod') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve -var="key_path=$KEY_FILE"'
                    }
                }
                sh 'ansible-playbook -i ansible/inventory/prod ansible/playbooks/deploy.yml'
            }
        }
    }
}

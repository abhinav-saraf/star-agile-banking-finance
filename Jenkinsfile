pipeline {
    agent any

    environment {
        TF_WORKSPACE = "test"
        ANSIBLE_HOST_KEY_CHECKING = "False"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/abhinav-saraf/star-agile-banking-finance.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t financeme-app .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker tag financeme-app sarafabhinav1997/financeme-app:latest'
                    sh 'docker push sarafabhinav1997/financeme-app:latest'
                }
            }
        }

        stage('Provision Test Infra') {
            steps {
                dir('terraform/test') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to Test') {
            steps {
                sh 'echo "Waiting for SSH port to be available..."'
                sh 'sleep 30'
                sh 'ansible-playbook -i ansible/test ansible/deploy.yml'
            }
        }

        stage('Manual Approval for Prod?') {
            steps {
                input message: 'Promote to production?'
            }
        }

        stage('Provision Prod Infra') {
            steps {
                dir('terraform/prod') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        
        stage('Deploy to Prod Server') {
            steps {
                sh 'echo "Waiting for SSH port to be available..."'
                sh 'sleep 30'
                sh 'ansible-playbook -i ansible/prod ansible/deploy.yml'
            }
        }
    }
}

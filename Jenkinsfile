pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                Terraform init
            }
        }
        stage('Test') {
            steps {
                Terraform plan --auto-approve
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}

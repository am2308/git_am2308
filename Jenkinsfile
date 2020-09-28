pipeline {
  agent any
  parameters {
    password (name: 'AWS_ACCESS_KEY_ID')
    password (name: 'AWS_SECRET_ACCESS_KEY')
  }
  environment {
    TF_WORKSPACE = 'dev' //Sets the Terraform Workspace
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
  } 
  stages {
    stage ('Checking Directory Path') {
      steps {
        sh "pwd"
        sh "ls -lart"
        sh "cd infra_provisioning"
        sh "ls -lart"
      }
    }  
    stage('Terraform Init') {
      steps {
        sh "pwd"
        sh "ls -lart"
        sh "terraform init"
      }
    }
    stage('Terraform Plan') {
      steps {
        sh "terraform plan -out=tfplan"
      }
    }
    stage('Terraform Apply') {
      steps {
        input 'Apply Plan'
        sh "cat tfplan"
      }
    }
  }
}

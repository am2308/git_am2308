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
    stage(‘Set Terraform path’) {
      steps {
        script {
          def tfHome = tool name: ‘Terraform’
          env.PATH = “${tfHome}:${env.PATH}”
        }
        sh "terraform — version"
      }
    }
    stage ('Checking Directory Path') {
      steps {
        sh """
        ls -lart
        cd infra_provisioning
        ls -lart
        """
      }
    }  
    stage('Terraform Init') {
      steps {
        sh """
        cd /root/InfraCode/infra_provisioning
        ls -lart
        terraform init
        """
      }
    }
    stage('Terraform Plan') {
      steps {
        sh """
        cd /root/InfraCode/infra_provisioning
        ls -lart
        terraform plan -out=tfplan
        """
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

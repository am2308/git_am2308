pipeline {
  agent any
  parameters {
    password (name: 'AWS_ACCESS_KEY_ID')
    password (name: 'AWS_SECRET_ACCESS_KEY')
  }
  environment {
    AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
  } 
  stages {
    stage('Set Terraform path') {
      steps {
        script {
          def tfHome = tool name: 'TerraformJenkins'
          env.PATH = "${tfHome}:${env.PATH}"
        }
        sh "terraform -version"
      }
    } 
    stage('Terraform Init') {
      steps {
        sh """
        cd /root/InfraCode/${params.env}/${params.version}/infra_provisioning
        ls -lart
        terraform init
        """
      }
    }
    stage('Terraform Plan') {
      steps {
        sh """
        cd /root/InfraCode/${params.env}/${params.version}/infra_provisioning
        ls -lart
        terraform plan -out=tfplan
        """
      }
    }
    stage('Terraform Apply') {
      steps {
        sh """
        cd /root/InfraCode/${params.env}/${params.version}/infra_provisioning
        cat tfplan
        """
      }
    }
    stage('Pushing back changes back to SCM') {
      steps {
        sh """
        cd /root/InfraCode
        git add .
        git commit -m "Updating SCM with latest tfstate files" 
        git push https://${params.GitUsername}:${GitPassword}%40github.com/am2308/git_am2308.git --all
        """
      }
    }
  }
}

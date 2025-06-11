pipeline {
  agent any

  environment {
    TF_VERSION = '1.6.6'
    TF_DIR     = 'terraform'
    AWS_DEFAULT_REGION = 'us-east-1'
  }

  options {
    timestamps()
    ansiColor('xterm')
  }

  tools {
    terraform "${TF_VERSION}"
  }

  stages {
    stage('📥 Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('🔐 AWS Credentials') {
      steps {
        withCredentials([
          [$class: 'AmazonWebServicesCredentialsBinding',
           accessKeyVariable: 'AWS_ACCESS_KEY_ID',
           secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
           credentialsId: 'aws-creds']
        ]) {
          echo 'AWS Credentials Loaded'
        }
      }
    }

    stage('🛠️ Terraform Init') {
      steps {
        dir("${TF_DIR}") {
          sh 'terraform init'
        }
      }
    }

    stage('✅ Terraform Validate') {
      steps {
        dir("${TF_DIR}") {
          sh 'terraform validate'
        }
      }
    }

    stage('🔍 Terraform Plan') {
      steps {
        dir("${TF_DIR}") {
          sh 'terraform plan -out=tfplan'
        }
      }
    }

    stage('🚀 Terraform Apply') {
      when {
        branch 'main'
      }
      steps {
        dir("${TF_DIR}") {
          sh 'terraform apply -auto-approve tfplan'
        }
      }
    }
  }

  post {
    success {
      echo '✅ EKS Cluster Created Successfully via Jenkins!'
    }
    failure {
      echo '❌ Jenkins Pipeline Failed.'
    }
  }
}

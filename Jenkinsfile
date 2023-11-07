pipeline {
    agent any

    stages {

        stage('Terraform Init') {
            steps {
                script {
                    dir("${env.Workspace}/ec2/modules/ec2-instance/") {
                        sh 'pwd'
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    input message: 'Deploy infrastructure?', parameters: [booleanParam(defaultValue: true, description: 'Check to deploy', name: 'DEPLOY')]
                    sh 'terraform apply tfplan'
                }
            }
        }
    }

    post {
        success {
            emailext subject: 'Terraform Apply Successful',
                body: 'Terraform apply was successful',
                to: 'your-email@example.com'
        }
        failure {
            emailext subject: 'Terraform Apply Failed',
                body: 'Terraform apply failed. Please check the Jenkins logs for details.',
                to: 'your-email@example.com'
        }
    }
}
pipeline {
agent any 
tools {
maven 'maven'
}

stages {
stage("Git Checkout"){
steps{
git 'https://github.com/sruthisodima/Medicure.git'
 }
 }
stage('Build the application'){
steps{
echo 'cleaning..compiling..testing..packaging..'
sh 'mvn clean install package'
 }
 }
 
stage('Publish HTML Report'){
steps{
    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/medicure-project-03/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
 }
}
stage('Docker build image') {
              steps {
                  
                  sh'sudo docker system prune -af '
                  sh 'sudo docker build -t sruthimotepalli/medicure:latest . '
              
                }
            }
stage('Docker login and push') {
              steps {
                   withCredentials([string(credentialsId: 'docpass', variable: 'docpasswd')]) {
                  sh 'sudo docker login -u sruthimotepalli -p ${docpasswd} '
                  sh 'sudo docker push sruthimotepalli/medicure:latest'
                  }
                }
        }    
 stage (' setting up Kubernetes with terraform '){
            steps{

                dir('terraform_files'){
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                sh 'sleep 20'
                }
               
            }
        }
stage('deploy to application to kubernetes'){
steps{
sh 'sudo chmod 600 ./terraform_files/jenkinskey.pem'    
sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/jenkinskey.pem medicure-deployment.yml ubuntu@172.31.36.166:/home/ubuntu/'
sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/jenkinskey.pem medicure-service.yml ubuntu@172.31.36.166:/home/ubuntu/'
script{
try{
sh 'ssh -i ./terraform_files/jenkinskey.pem ubuntu@172.31.36.166 kubectl apply -f .'
}catch(error)
{
sh 'ssh -i ./terraform_files/jenkinskey.pem ubuntu@172.31.36.166 kubectl apply -f .'
}
}
}
}
}
}

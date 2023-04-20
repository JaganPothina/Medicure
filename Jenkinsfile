pipeline {
agent any 
tools {
maven 'maven'
}

stages {
stage("Git Checkout"){
steps{
git 'https://github.com/JaganPothina/Medicure-Project.git'
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
    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/medicure/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
 }
}
stage('Docker build image') {
              steps {
                  
                  sh'sudo docker system prune -af '
                  sh 'sudo docker build -t 9182924985/medicure:latest . '
              
                }
            }
stage('Docker login and push') {
              steps {
                   withCredentials([string(credentialsId: 'docpass', variable: 'docpasswd')]) {
                  sh 'sudo docker login -u 9182924985 -p ${docpasswd} '
                  sh 'sudo docker push 9182924985/medicure:latest'
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
sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/jenkinskey.pem medicure-deployment.yml ubuntu@172.31.196-117:/home/ubuntu/'
sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/jenkinskey.pem medicure-service.yml ubuntu@172.31.196-117:/home/ubuntu/'
script{
try{
sh 'ssh -i ./terraform_files/jenkinskey.pem ubuntu@172.31.196-117 kubectl apply -f .'
}catch(error)
{
sh 'ssh -i ./terraform_files/jenkinskey.pem ubuntu@172.31-196-117 kubectl apply -f .'
}
}
}
}
}
}

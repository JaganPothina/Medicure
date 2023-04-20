provider aws {
    region = "us-east-1"
}
resource "aws_instance" "jenkins-medicure" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.medium"
  key_name = "jenkinskey"
  vpc_security_group_ids= ["sg-0c7aae9017fc5106b"]
  
   tags = {
    Name = "Jenkins-medicure"
  }
}

output "Jenkins-server_public_ip" {

  value = aws_instance.jenkins-medicure.public_ip
  
}

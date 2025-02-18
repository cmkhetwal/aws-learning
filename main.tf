provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "master" {
  ami           = "ami-04b4f1a9cf54c11d0" 
  instance_type = "t2.medium"
  user_data = file("${path.module}/setup.sh")
  key_name      = "cicd"

  tags = {
    Name = "master-server"
  }

}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.43.0"
    }
  }
}
provider "aws" {
region = "us-east-1"
}


resource "aws_instance" "demo1" {
  ami = "ami-033a1ebf088e56e81"
  instance_type = "t2.micro"
  key_name = "windows-key"
 
}

resource "null_resource" "n1" {
  connection {
      type = "ssh"
      user = "ec2-user"
      private_key =file("~/Downloads/windows-key.pem")
      host = aws_instance.demo1.public_ip
  }
  provisioner "local-exec" {
    command = "echo hello world"
  }

  provisioner "remote-exec" {
   inline = [
    "sudo useradd ashley3",
    "mkdir terraform3",
   ]
  }
  provisioner "file" {
    source = "~/Downloads/windows-key.pem"
    destination = "/tmp/windows-key.pem"
  }
  depends_on = [ aws_instance.demo1 ]
}
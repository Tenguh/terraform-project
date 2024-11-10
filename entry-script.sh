#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user #adding ec2 user to docker group
docker run -d -p 8080:80 nginx #running nginx in detached mode
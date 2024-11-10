# Automated AWS infrastructure using Terraform


# over view
This is a simple automated Terraform project. i used Docker in running the Nginx image by creating a shell script, used in installing Docker on the sever.
=======

###### GitHub setup
1) Fork GitHub Repository by using the existing repo "devops-fully-automated-infra" (https://github.com/cvamsikrishna11/devops-fully-automated-infra)     
    - Go to GitHub (github.com)
    - Login to your GitHub Account
    - **Fork repository "devops-fully-automated-infra" (https://github.com/cvamsikrishna11/devops-fully-automated-infra.git) & name it "devops-fully-automated-infra"**
    - Clone your newly created repo to your local


2) ###### Jenkins
    - Create 2 **lastest Amazon Linux 2 VM** instance and call it "myapp-server-1" $ "myapp-server-2"
    - Instance type: t2.small $ t2.micro
    - Security Group (Open): 8080, 22 to 0.0.0.0/0
    - Key pair: Select or create a new keypair or automate ssh-key-pair by configuring the key in a terraforn config file.
- entry-script1 
  install Docker and run nginx image in "myapp-server-1:
    
    #!/bin/bash
    sudo yum update -y && sudo yum install -y docker
    sudo systemctl start docker
    sudo usermod -aG docker ec2-user
    docker run -d -p 8080:80 nginx


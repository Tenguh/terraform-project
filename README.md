# Automated AWS infrastructure using Terraform

This is a simple DevOps automated AWS infrastructure. 
I used Terraform to access the Nginx image from the browser with the help of a bash script which i used in installing Docker on the sever.
Then Configuring Terraform backend with AWS S3 and DynamoDB state locking.
 
 ##### Prerequisites 
  - Install and configure AWS CLI and Terraform
  - Install a code editor(VS Code).
  - Understand what state file is.
  - What is statefile lock and the importances of locking the statefile.
  - What type of backend can be used.

1) ###### Process
a) Start by Creating a simple infrastructure using Modules
b) Next, use an entry script in installing docker and run the Nginx image in the server.
c) Create a backend with Terraform backend code block which will build S3 bucket in your AWS account and the  statefile will be saved there.
d) Write code for DynamoDB state locking via Terraform and see how it looks in our AWS account.

##### a) Creating the infrastructure
Always validate if AWS CLI & Terraform are installed using the commands on your CLI:

$ aws --version
$ terraform --version
After confirming aws and terraform are installed, we can start creating our infrastructure. provider.tf file in VS code and input the provider block.
- in other to initialize your working environment, run the command ;
$ terraform init


have these in mind while creating the infrastructure
 use the following
    - Lastest Amazon Linux 2 VM
    - t2.micro and t2.small
    - open port 8080, 22 to 0.0.0.0/0
    - create a new keypair 

- Next, we create a variable block (variables.tf) and provide the variables to be used.

- Also create a folder and call it main.tf
- In this folder, create a VPC using the Terraform resource block for VPC

- After creating the VPC, we now create a folder call modules. In this folder we create subfolders for:
- security_group
- subnet
- webserver


- In each subfolder create files for main.tfm variables.tf and outputs.tf as below;

for security_group
  - main.tf (Create aws security group using security_group resource and AMI using data source)
  - variables.tf ( create variables used in creating the security group)
  - outputs.tf ( include what you will like to output when running either the plan command or apply command eg security group ID )

for subnet
  - main.tf (create AWS Subnet, internet gateway and route_table using Terraform resource block)
  - varaibles.tf (create variables per the resource created)
  - outputs.tf (subnet ID )

for webserver
  - main.tf(Create an AMI using Data source block and create an instance using resource block)
  - variables.tf (include Variables as needed)
  - outputs.tf( you may want to output the instance ID)


  The next and very important step is to create Modules for the infrastructure created in the root main.tf file.
create Modules for;
  - subnet
  - security_group
  - webserver ( 2 for the webserver just to illustrate the use of modules)

  RUN
  $ terraform plan 
  if ok run the apply command
  $ terraform apply -auto-approve to create the infracture in YOUR ACCOUNT

##### b) Configure Terraform to install Docker and run Nginx Image using the script below,
entry-script 
  Installing Docker:
  Create a file call it entry_script.sh
  Input the command below in the file   
    #!/bin/bash
    sudo yum update -y && sudo yum install -y docker
    sudo systemctl start docker
    sudo usermod -aG docker ec2-user
    docker run -d -p 8080:80 nginx!

   - run $ terraform apply -auto-approve
   - ssh into the server
   - verify if docker is installed by running the command
     $ docker -version
   - copy the public ip of any of the servers
   - paste on your browser with the nginx post number(public_ip:8080)
   - you should be able to view the nginx image on your browser.

   ##### c) Create a backend with Terraform backend code block 
   - Create a bucket using the console
   - Enable versioning and encrytion in the S3 Bucket
   - Create a file and name it backend.tf in VS code
   - In this file create  the backend configuration using terraform documentation.
   - Make sure to indicate the backend you are using, the name of the bucket and the region in which the bucket was created.
   - Give it a key by creating a floder in s3 in which the statefile will be saved.

   RUN $ terraform init 
   to initialize again since another root module has been added.
   - run $ terraform plan to view your infrastructure
   - run $ terraform apply -auto-approve to create the folder and save the statefile.

##### d) Writing code for DynamoDB state locking
 - After we creating the S3 bucket and migrated our state file in to it we now create DynamoDB state locking.
 - this is done by creating a table for Terraform state locking giving it a simple hash LockID key and one string attribute. 
 - We can write the code for this in our backend.tf file.
 - After that, run $ terraform apply command for Terraform to create our table within the DynamoDB service.
 - update our backend code block within our backend.tf file with the name of the recently created database.
 - run $ terraform init -reconfigure to reconfigure our state locking.

 
    [alt text](image.png)


2) ##### Securing the STATEFILE 
 - Use Remote Terraform State when working in a team ie AMAZON S3 
 - can also use S3 with DynamoDB
 - reference it using the backend block  in the main.tf file


3) ##### Best Practice
- enable S3 versioning so you cn easily roll back to previous versions and allow for state recovery.
- enable encryption to secure the statefile in transit.
- never store the statefile in source control because it is written in plain text which may contain secrets.


4) ##### Useful links:
- Backend block configuration: https://developer.hashicorp.com/terraform/language/backend
- Remote state: https:///www.terraform.io/docs/state/remote.html
- AWS S3: https://aws.amazon.com/s3/
# Automated AWS infrastructure using Terraform

This is a simple DevOps automated AWS infrastructure. 
In this project I used Terraform in automating the infrastructure from scratch, install Docker and ran the Nginx image on my servers with the help of a bash script.
Next, I Configured Terraform backend with AWS S3 to save my statefile.This is useful for team collaboration and not forgetting security which is of prior importance in every environment.
Also, i used AWS DynamoDB state locking in locking the state. With state locking, team members work simultaneously on the infrastructure without overwritting the state.Hence, state is modified at every stage.

In other to follow up with the project, you will need the following prrequisites:
 
 ##### Prerequisites 
  - Install and configure AWS CLI and Terraform
  - Install a code editor(VS Code).
  - Understand what state file is.
  - What is statefile lock and the importances of locking the statefile.
  - What type of backend can be used.

1) ###### Proces
    This Demo is done in 4 different stages as listed below;
a) Start by Creating a simple infrastructure using Modules
b) Next, use an entry script in installing docker and run the Nginx image in the server.
c) Create a backend with Terraform backend code block which will build S3 bucket in your AWS account and the  statefile will be saved there.
d) Write code for DynamoDB state locking via Terraform and see how it looks in our AWS account.

##### a) Creating the infrastructure
If you did install AWS CLI and Terraform always validate if they are installed using the follwing commands on your CLI:

$ aws --version
$ terraform --version
After confirming aws and terraform are installed, we can start creating our infrastructure. 
- create a file called provider.tf in VS code and input the provider block. using the latest vision is best.

- in other to initialize your working environment, run the command ;
$ terraform init


Have these in mind while creating the infrastructure
 use the following
    - Lastest Amazon Linux 2 VM
    - t2.micro and t2.small
    - open port 8080, 22 to 0.0.0.0/0
    - create a new keypair 

- Next, we create a variable block (variables.tf) and provide the variables to be used.

- Also create a folder and call it main.tf
- In this folder, create a VPC using the Terraform resource block for VPC

After creating the VPC, we now create a folder call modules. In this folder we create subfolders for:
 - security_group
 - subnet
 - webserver


- In each subfolder create files for main.tf, variables.tf and outputs.tf as below;

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


  The next and very important step is to create Modules for the infrastructure created in the root main.tf file where the VPC was created.
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
  Create a file and call it entry_script.sh
  Input the script below in the file. this script is used in installing Docker and running Nginx image on the servers
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

   RUN $ terraform init -reconfigure
   to initialize again since another root module has been added.
   - run $ terraform plan to view your infrastructure
   - run $ terraform apply -auto-approve to create the folder and save the statefile.

##### d) Writing code for DynamoDB state locking
 - After creating the S3 bucket and migrating our state file in to it, we now create DynamoDB state locking.
 - this is done by creating a table for Terraform state locking giving it a simple hash LockID key and one string attribute. 
 - We can write the code for this in our backend.tf file.
 - After that, run $ terraform init -recongiure since our backend has been modified.
 - run terraform apply -auto-approve to create our table within the DynamoDB service in AWS.
 - after the dynamodb table has been created, update our backend code block within our backend.tf file with the name of the recently created database.
 - run $ terraform init -reconfigure to reconfigure our state locking.

To avoid unnecessary costs, clean the resources by running the command $ terraform destroy.
Only use this command out of your production environment.

2) ##### Best Practice
- enable S3 versioning so you can easily roll back to previous versions and allow for state recovery.
- enable encryption to secure the statefile in transit.
- never store the statefile in source control because it is written in plain text which may contain secrets.
  
3) ##### My Challanges while doing this project
  1) Using another persons machine which has been configured with his credentials to push code to my git repo with no success.
  - what i did
     -Tried to configure my own credentials using the command below;
    $ git config --global user.name "Your Name"
    $ git config --global user.email "name@email"
   this didnot work.
     - added the user as a colaborator to my project.
     - go to your github account
     - click on settings
     - click on collaborator
     - select add collaborator
     - input the username of his/her github account
     - click on add
     - a mail requesting his approval will be sent to the person
     - once approved, i was able to push to my repo.
   
   this is not the best way to go about it. it is still a work in progress for me. 
   will welcome ideas from anyone on how to go about it.

   2) updating the backend code block within the backend.tf file with the name of the recently created database and enabling encryption.
      after updating the backend.tf file and ranning $ terraform init -reconfigure to update the working environment successfully, i ran $ terraform plan and this error popped up
      ![image](https://github.com/user-attachments/assets/cb8bf305-77ba-41eb-9869-2b525fa16cf1)

Still working on the solution to that. 
YOUR IDEAS ARE WELCOMED


4) ##### Useful links:
- Backend block configuration: https://developer.hashicorp.com/terraform/language/backend
- Remote state: https:///www.terraform.io/docs/state/remote.html
- AWS S3: https://aws.amazon.com/s3/
- 
Conclusion:

The aim of this project was;
- first to create an infrastructure using terraform from scratch.
- Secondly, to create a remote Terraform backend by using S3 and DynamoDB with state locking.
- Also this was for better understanding of what theory says about statefiles and how Terraform backend is created with with S3, which helps in collaboration amongs team members. Not forgetting state lock with the help of dynamodb, which helps in avoiding unpredictable issues when the state is being modified eg overwritting.
- for anyone wanting a project as such to practice, feel free and please don't forget to drop a feedback
  
                                  THANK YOU FOR GOING THROUGH MY PROJECT.



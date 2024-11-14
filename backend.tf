terraform {
  backend "s3" {
    bucket = "project-statefile-bucket"
    region = "us-east-1"
    key    = "modules/terraform.tfstate" #create a folder called modules in s3 and save the statefile in
  }
}


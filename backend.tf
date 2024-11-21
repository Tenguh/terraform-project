terraform {
  backend "s3" {
    bucket = "project-statefile-bucket"
    region = "us-east-1"
    key    = "modules/terraform.tfstate" 
    dynamodb_table = "terraform_state_lock"
    encrypt = true
  }
}



resource "aws_dynamodb_table" "terraform_state_lock" {
   name = "terraform_state_lock"
   billing_mode = "PAY_PER_REQUEST"
   hash_key = "LockID"

   attribute {
       name = "LockID"
       type = "S"
   }
}




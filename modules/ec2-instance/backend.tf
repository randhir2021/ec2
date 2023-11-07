#terraform {
#  #Please make sure to replace this with your s3 and dynamodb name
#  backend "s3" {
#    bucket         = "terraform-backend2023"
#    key            = "${var.environment}/terraform.tfstate"
#    region         = "us-west-2"
#    dynamodb_table = "terraform-state-lock"
#    encrypt        = true
#  }
#}

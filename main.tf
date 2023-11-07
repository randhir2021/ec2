module "ec2-dev" {
  source         = "./modules/ec2-instance"
  instance_type  = "t2.micro"
  instance_count = 1
  environment    = "dev"
}

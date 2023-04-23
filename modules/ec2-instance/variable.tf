# variable "ami_id" {
#   type = string
# }

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type = number
}

variable "environment" {
  type = string
}
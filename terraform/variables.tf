 variable "instance_type" {
    description = "Tipo de instancia"
    type        = string
    default     = "t2.micro"
  }

 variable "ami" {
   description = "AMI"
   type        = string
   default     = "ami-0d71ea30463e0ff8d"
 }

 variable "subnet_id" {
   description = "Id de subnet"
   type        = string
   default     = "subnet-0bcb76bfbc6174487"
 }

 variable "vpc_security_group_ids" {
   description = "VPC"
   type        = string
   default     = "sg-04c0e4ce68d04e6ac"
 }

 variable "region" {
   description = "Region"
   type        = string
   default     = "eu-west-1"
 }

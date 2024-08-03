variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "ap-southeast-2"
}

variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
  default     = "ami-024ebc7de0fc64e44"
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "project"
}

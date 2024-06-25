variable "vpc_id" {
  type = string
  default = "vpc-06f2f980fb755d55b"
}

variable "subnet_id" {
  type = string
  default = "subnet-09e67f2d1102acc25"
}

variable "ami_id" {
  type = string
  default = "ami-06f59e43b31a49ecc"
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "path_to_public_key" {
  type = string
  default = "~/.ssh/recsys-key.pub"
}
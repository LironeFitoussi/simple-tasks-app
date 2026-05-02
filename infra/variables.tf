variable "instance_type" {
  default = "t3.micro"
}

variable "security_group_id" {
  default = "sg-0a9707fb4465b08af"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 3
}

variable "desired_capacity" {
  default = 1
}

variable "vpc_ip" {
  default = "10.0.0.0/16"
}

variable "pub_ip" {
  default = "10.0.1.0/24"
  
}


variable "prv_ip" {
  default = "10.0.2.0/24"
}



variable "ami" {
  default = "ami-03fa4afc89e4a8a09"

}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  default = "vpc-key"
  
}
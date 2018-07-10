variable "name" {
  default = "enplaylist.com"
}

variable "region" {
  default = "us-west-2"
}

variable "azs" {
  default = ["us-west-2a"]
  type    = "list"
}

variable "env" {
  default = "staging"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

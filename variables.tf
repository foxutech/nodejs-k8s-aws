variable "name" {
  default = "enplaylist.com"
}

variable "region" {
  default = "us-west-1"
}

variable "azs" {
  default = ["us-west-1a", "us-west-1c", "us-west-1d"]
  type    = "list"
}

variable "env" {
  default = "staging"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

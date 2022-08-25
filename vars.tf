variable "name_" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "public_sub_cidr" {
  type = list
}
variable "private_sub_cidr"{
  type = list
}
variable "availabilty_zone"{
  type = list
}
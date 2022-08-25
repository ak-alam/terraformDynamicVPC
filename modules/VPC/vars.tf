variable "name" {
  type = string
}
variable "vpcCidr" {
  type = string
}
variable "publicSubCidr" {
  type = list
}
variable "privateSubCidr"{
  type = list
}
variable "availabiltyZone"{
  type = list
}
variable "create_nat" {
  type = bool
  default = true
}
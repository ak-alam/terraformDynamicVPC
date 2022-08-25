module "VPCNetwork" {
    source = "./modules/VPC"
    name = var.name_
    vpcCidr = var.vpc_cidr
    publicSubCidr = var.public_sub_cidr
    privateSubCidr = var.private_sub_cidr
    availabiltyZone = var.availabilty_zone
}

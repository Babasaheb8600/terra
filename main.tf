module "vpc" {
  source    = "./module/vpc"
  vpc_cidr  = var.vpc_cidr
  vpc_name  = var.vpc_name
}

module "subnet" {
  source     = "./module/subnet"
  vpc_id     = module.vpc.vpc_id
  subnet_cidr = var.subnet_cidr
  subnet_name = var.subnet_name
  az          = var.az
}

module "igw" {
  source = "./module/igw"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source     = "./module/route_table"
  vpc_id     = module.vpc.vpc_id
  igw_id     = module.igw.igw_id
  subnet_id  = module.subnet.subnet_id
}

module "security_group" {
  source = "./module/security_group"
  vpc_id = module.vpc.vpc_id
}

module "key_pair" {
  source          = "./module/key_pair"
  key_name        = var.key_name
  public_key_path = var.public_key_path
}

module "ec2" {
  source        = "./module/ec2"
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.subnet.subnet_id
  key_name      = module.key_pair.key_name
  sg_id         = module.security_group.sg_id
  name          = "web-server"
}

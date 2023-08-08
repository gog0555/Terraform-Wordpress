module "network" {
  source = "../../modules/network"

  env  = var.env
  name = var.name

  vpc_id   = module.network.vpc_id
  vpc_cidr = var.vpc_cidr
  subnets  = var.subnets
}


module "ec2" {
  source = "../../modules/ec2"

  env  = var.env
  name = var.name

  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets

  ami           = var.ami
  instance_type = var.instance_type

}

module "rds" {
  source = "../../modules/rds"

  env  = var.env
  name = var.name

  ec2sg_id = module.ec2.ec2sg_id

  db_param_character = var.db_param_character
  db_storage         = var.db_storage
  db_storage_type    = var.db_storage_type
  db_name            = var.db_name
  db_engine          = var.db_engine
  db_engine_version  = var.db_engine_version
  db_instance_class  = var.db_instance_class
  db_username        = var.db_username
  db_password        = var.db_password
  db_multi_az        = var.db_multi_az

  db_snapshot_identifier = var.db_snapshot_identifier

  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets

}

module "elb" {
  source = "../../modules/elb"

  env  = var.env
  name = var.name

  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets

  intance1a_id = module.ec2.intance1a_id
  intance1c_id = module.ec2.intance1c_id

  load_balancer_type = var.load_balancer_type
  health_check_path  = var.health_check_path

  certificate_arn   = module.route53.certificate_arn
  HTTPSlistener_arn = module.route53.HTTPSlistener_arn
}


module "route53" {
  source = "../../modules/route53"

  env  = var.env
  name = var.name

  my_domain = var.my_domain
  dns_name  = module.elb.dns_name
  zone_id   = module.elb.zone_id

  targetgroup_arn = module.elb.targetgroup_arn
  elb_arn         = module.elb.elb_arn
}
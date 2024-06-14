provider "aws" {
  region      = var.region
  max_retries = 1
  default_tags {
    tags = var.default_tags
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.0"
    }
  }
}
module "VPC" {
  source = "../../modules/VirtualNetwork"

  virtual_network_address_space            = "172.31.0.0/16"
  main_subnet_application_address_prefixes = "172.31.0.0/20"
  subnet_data_address_1_prefixes           = "172.31.16.0/20"
  subnet_data_address_2_prefixes           = "172.31.32.0/20"
  default_tags                             = var.default_tags
  stage_name                               = var.stage_name
}

module "SecurityGroups" {
  source = "../../modules/SecurityGroups"

  vpc_id         = module.VPC.vpc_main_id
  default_tags   = var.default_tags
  vpc_cidr_range = module.VPC.vpc_cidr_range
}

module "ElastiCache" {
  source    = "../../modules/ElastiCache"
  redis_sg_id = module.SecurityGroups.redis_sg_id
  node_type = "cache.t2.small"
  tags      = var.default_tags
  subnet_id = module.VPC.database-subnet-id-1
}

module "RDS" {
  source = "../../modules/RDS"
  subnet_ids = [
    module.VPC.database-subnet-id-1,
    module.VPC.database-subnet-id-2,
  ]
  mysql_password = var.mysql_password
  tags           = var.default_tags
  rds_sg_id = module.SecurityGroups.rds_sg_id
}

module "KeyPair" {
  source = "../../modules/KeyPair"

  key_name = "Openedx-key"
}

module "CWLogs" {
  source = "../../modules/CloudWatchLogs"

  ec2_log_group_name = "/aws/edx/edx-application"
  log_retention_in_days = 3
}

module "IAM" {
  source = "../../modules/IAM"
  ec2_log_group_arn = module.CWLogs.ec2_log_group_arn
}

module "EC2" {
  source            = "../../modules/VirtualMachine"
  subnet_id_public  = module.VPC.application-main-subnet-id
  subnet_id_private = module.VPC.database-subnet-id-1
  edx_sg_id         = module.SecurityGroups.edx_sg_id
  mongodb_sg_id     = module.SecurityGroups.mongodb_sg_id
  default_tags      = var.default_tags
  openedx_ami       = "ami-0d5db88fc8980db76"
  mongodb_ami       = "ami-0d73fbec275a3e034"
  key_name          = module.KeyPair.key_name
  stage_name        = var.stage_name
  aws_cloudwatch_agent_profile_role_name = module.IAM.aws_cloudwatch_agent_profile_role_name
  ec2_log_group_name = module.CWLogs.ec2_log_group_name
}

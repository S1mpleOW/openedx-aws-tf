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
  backend "s3" {
    bucket  = "tf-s3-be"
    key     = "terraform/development"
    region  = "ap-southeast-1"
  }
}
# module "VPC" {
#   source = "../../modules/VirtualNetwork"

#   virtual_network_address_space    = "172.31.0.0/16"
#   subnet_public_address_prefixes_1 = "172.31.0.0/20"
#   subnet_public_address_prefixes_2 = "172.31.16.0/20"
#   subnet_public_address_prefixes_3 = "172.31.32.0/20"
#   default_tags                     = var.default_tags
#   stage_name                       = var.stage_name
#   region                           = var.region
# }

# module "SecurityGroups" {
#   source = "../../modules/SecurityGroups"

#   vpc_id         = module.VPC.vpc_main_id
#   default_tags   = var.default_tags
#   vpc_cidr_range = module.VPC.vpc_cidr_range
# }

# module "ElastiCache" {
#   source      = "../../modules/ElastiCache"
#   redis_sg_id = module.SecurityGroups.redis_sg_id
#   node_type   = "cache.t2.small"
#   tags        = var.default_tags
#   subnet_id   = module.VPC.public_subnet_id_2
# }

# module "RDS" {
#   source = "../../modules/RDS"
#   subnet_ids = [
#     module.VPC.public_subnet_id_2,
#     module.VPC.public_subnet_id_3,
#   ]
#   mysql_password = var.mysql_password
#   tags           = var.default_tags
#   rds_sg_id      = module.SecurityGroups.rds_sg_id
# }

# module "KeyPair" {
#   source = "../../modules/KeyPair"

#   key_name = "Openedx-key"
# }

module "CWLogs" {
  source = "../../modules/CloudWatchLogs"

  ec2_log_group_name    = "/aws/edx/edx-application"
  log_retention_in_days = 3
}

module "IAM" {
  source            = "../../modules/IAM"
  ec2_log_group_arn = "arn:aws:logs:ap-southeast-1:856971625808:log-group:/aws/edx/application:*"
  default_tags      = var.default_tags
  stage_name        = var.stage_name
}

# module "EC2" {
#   source                                 = "../../modules/VirtualMachine"
#   subnet_id_application                  = module.VPC.public_subnet_id_1
#   subnet_id_database                     = module.VPC.public_subnet_id_2
#   edx_sg_id                              = module.SecurityGroups.edx_sg_id
#   mongodb_sg_id                          = module.SecurityGroups.mongodb_sg_id
#   default_tags                           = var.default_tags
#   openedx_ami                            = "ami-0c37aff3afbd5e16e"
#   mongodb_ami                            = "ami-0d73fbec275a3e034"
#   key_name                               = module.KeyPair.key_name
#   stage_name                             = var.stage_name
#   aws_cloudwatch_agent_profile_role_name = module.IAM.aws_cloudwatch_agent_profile_role_name
#   MYSQL_HOST                             = module.RDS.endpoint_mysql_edx
#   MYSQL_ROOT_PASSWORD                    = module.RDS.password_mysql_edx
#   MYSQL_ROOT_USERNAME                    = module.RDS.username_mysql_edx
#   REDIS_HOST                             = module.ElastiCache.endpoint_redis_edx
#   SMTP_HOST                              = var.SMTP_HOST
#   SMTP_USERNAME                          = var.SMTP_USERNAME
#   SMTP_PASSWORD                          = var.SMTP_PASSWORD
#   OPENEDX_AWS_SECRET_ACCESS_KEY          = module.IAM.aws_s3_secret_key
#   OPENEDX_AWS_ACCESS_KEY                 = module.IAM.aws_s3_access_key
#   S3_PROFILE_IMAGE_BUCKET                = module.S3.openedx_fastai_profile_images_bucket_name
#   S3_REGION                              = var.region
#   S3_STORAGE_BUCKET                      = module.S3.openedx_fastai_bucket_name
#   depends_on                             = [module.CWLogs, module.IAM, module.RDS, module.ElastiCache, module.VPC, module.SecurityGroups]
# }

module "S3" {
  source       = "../../modules/S3"
  default_tags = var.default_tags
  stage_name   = var.stage_name
  iam_s3_arn   = module.IAM.iam_s3_arn
}

module "CloudFront" {
  source = "../../modules/CloudFront"
  default_tags = var.default_tags
  stage_name   = var.stage_name
}

output "cloudfront_domain_name" {
  value = module.CloudFront.cloudfront_domain_name
}

# output "endpoint_redis_edx" {
#   value = module.ElastiCache.endpoint_redis_edx
# }

# output "endpoint_mysql_edx" {
#   value = module.RDS.endpoint_mysql_edx
# }

# output "edx_public_ip" {
#   value = module.EC2.edx_public_ip
# }

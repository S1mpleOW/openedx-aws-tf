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
module "VPC" {
  source = "../../modules/VirtualNetwork"

  virtual_network_address_space    = "10.0.0.0/16"
  subnet_public_address_prefixes_1 = "10.0.0.0/24"
  subnet_public_address_prefixes_2 = "10.0.1.0/24"
  subnet_private_address_prefixes_2 = "10.0.2.0/24"
  default_tags                     = var.default_tags
  stage_name                       = var.stage_name
  region                           = var.region
}

module "SecurityGroups" {
  source = "../../modules/SecurityGroups"

  vpc_id         = module.VPC.vpc_main_id
  default_tags   = var.default_tags
  vpc_cidr_range = module.VPC.vpc_cidr_range
}

module "ElastiCache" {
  source      = "../../modules/ElastiCache"
  redis_sg_id = module.SecurityGroups.redis_sg_id
  node_type   = "cache.t2.small"
  tags        = var.default_tags
  subnet_id   = module.VPC.public_subnet_id_1
}

module "RDS" {
  source = "../../modules/RDS"
  subnet_ids = [
    module.VPC.public_subnet_id_1,
    module.VPC.public_subnet_id_2,
  ]
  mysql_password = var.mysql_password
  tags           = var.default_tags
  rds_sg_id      = module.SecurityGroups.rds_sg_id
}

module "DocumentDB" {
  source = "../../modules/DocumentDB"

  doc_db_password     = var.doc_db_password
  availability_zones  = ["${var.region}a", "${var.region}b"]
  tags                = var.default_tags
  subnet_ids          = [
    module.VPC.public_subnet_id_1,
    module.VPC.public_subnet_id_2,
  ]
  stage               = var.stage_name
  vpc_sg_ids = [module.SecurityGroups.mongodb_sg_id]
}

module "KeyPair" {
  source = "../../modules/KeyPair"

  key_name = "OpenedX-key"
}

module "SNS" {
  source = "../../modules/SNS"
  sns_name = "OpenedXSNSSendDiscordNotification"
  aws_lambda_function_arn = "arn:aws:lambda:ap-southeast-1:856971625808:function:SendDiscordNotification"
  tags = var.default_tags
}

module "CWLogs" {
  source = "../../modules/CloudWatchLogs"

  ec2_log_group_name    = "/aws/edx/application"
  log_retention_in_days = 3
  sns_topic_arn = module.SNS.sns_topic_arn
  ec2_instance_id = module.EC2.edx_instance_id
}


module "IAM" {
  source            = "../../modules/IAM"
  ec2_log_group_arn = "arn:aws:logs:ap-southeast-1:856971625808:log-group:/aws/edx/application:*"
  default_tags      = var.default_tags
  stage_name        = var.stage_name
}

module "ElasticSearch" {
  source = "../../modules/ElasticSearch"
  domain = "fastai-es-${var.stage_name}"
  stage_name   = var.stage_name
  default_tags = var.default_tags
  subnet_id    = module.VPC.public_subnet_id_1
  es_sg_id     = module.SecurityGroups.elasticsearch_sg_id
}

module "EC2" {
  source                                 = "../../modules/VirtualMachine"
  subnet_id_application                  = module.VPC.public_subnet_id_1
  subnet_id_database                     = module.VPC.public_subnet_id_2
  edx_sg_id                              = module.SecurityGroups.edx_sg_id
  mongodb_sg_id                          = module.SecurityGroups.mongodb_sg_id
  default_tags                           = var.default_tags
  openedx_ami                            = "ami-022affc20f19fa55d"
  key_name                               = module.KeyPair.key_name
  stage_name                             = var.stage_name
  aws_cloudwatch_agent_profile_role_name = module.IAM.aws_cloudwatch_agent_profile_role_name
  MONGODB_HOST = module.DocumentDB.documentdb_endpoint
  MONGODB_USERNAME                       = module.DocumentDB.documentdb_master_username
  MONGODB_PASSWORD                       = module.DocumentDB.documentdb_master_password
  MYSQL_HOST                             = ""
  MYSQL_ROOT_PASSWORD                    = ""
  MYSQL_ROOT_USERNAME                    = ""
  REDIS_HOST                             = ""
  SMTP_HOST                              = var.SMTP_HOST
  SMTP_USERNAME                          = var.SMTP_USERNAME
  SMTP_PASSWORD                          = var.SMTP_PASSWORD
  ELASTICSEARCH_HOST                     = ""
  OPENEDX_AWS_SECRET_ACCESS_KEY          = module.IAM.aws_s3_secret_key
  OPENEDX_AWS_ACCESS_KEY                 = module.IAM.aws_s3_access_key
  S3_PROFILE_IMAGE_BUCKET                = module.S3.openedx_fastai_profile_images_bucket_name
  S3_REGION                              = var.region
  S3_STORAGE_BUCKET                      = module.S3.openedx_fastai_bucket_name
  # depends_on                             = [module.CWLogs, module.IAM, module.RDS, module.ElastiCache, module.VPC, module.SecurityGroups, module.DocumentDB, module.ElasticSearch]
}

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
  default_cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  default_origin_request_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
}

output "cloudfront_domain_name" {
  value = module.CloudFront.cloudfront_domain_name
}

output "endpoint_redis_edx" {
  value = module.ElastiCache.endpoint_redis_edx
}

output "endpoint_mysql_edx" {
  value = module.RDS.endpoint_mysql_edx
}

output "endpoint_es_edx" {
  value = module.ElasticSearch.es_domain_endpoint
}

output "mongodb_host" {
  value = module.DocumentDB.documentdb_endpoint
}

output "edx_public_ip" {
  value = module.EC2.edx_public_ip
}

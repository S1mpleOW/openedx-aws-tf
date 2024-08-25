variable "default_tags" {
  type = map(string)
}

variable "openedx_ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "edx_sg_id" {
  type = string
}

variable "mongodb_sg_id" {
  type = string
}

variable "subnet_id_application" {
  type = string
}

variable "subnet_id_database" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "aws_cloudwatch_agent_profile_role_name" {
  type = string
}


variable "MYSQL_HOST" {
  type = string
}

variable "MYSQL_ROOT_USERNAME" {
  type = string
}

variable "MYSQL_ROOT_PASSWORD" {
  type = string
}

variable "REDIS_HOST" {
  type = string
}

variable "SMTP_HOST" {
  type = string
}

variable "SMTP_USERNAME" {
  type = string
}

variable "SMTP_PASSWORD" {
  type = string
}

variable "OPENEDX_AWS_ACCESS_KEY" {
  type = string
}

variable "OPENEDX_AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "S3_REGION" {
  type = string
}

variable "S3_STORAGE_BUCKET" {
  type = string
}

variable "S3_PROFILE_IMAGE_BUCKET" {
  type = string
}

variable "ELASTICSEARCH_HOST" {
  type = string
}

variable "MONGODB_HOST" {
  type = string
}

variable "MONGODB_USERNAME" {
  type = string
}

variable "MONGODB_PASSWORD" {
  type = string
}

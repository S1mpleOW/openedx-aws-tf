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

variable "subnet_id_public" {
  type = string
}

variable "subnet_id_private" {
  type = string
}

variable "mongodb_ami" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "aws_cloudwatch_agent_profile_role_name" {
  type = string
}

variable "ec2_log_group_name" {
  type = string

}

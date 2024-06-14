variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "mysql_password" {
  type = string
}

variable "rds_sg_id" {
  type = string
}

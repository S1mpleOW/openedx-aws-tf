variable "doc_db_password" {
  description = "The password for the DocumentDB cluster"
  type        = string
}

variable "availability_zones" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "vpc_sg_ids" {
  type = list(string)
}

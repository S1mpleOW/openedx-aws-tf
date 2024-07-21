variable "stage_name" {
  type = string
}

variable "default_tags" {
  type = map(string)
}

variable "domain" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "es_sg_id" {
  type = string
}

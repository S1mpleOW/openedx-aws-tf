variable "virtual_network_address_space" {
  type = string
}

variable "subnet_public_address_prefixes_1" {
  type = string
}

variable "subnet_public_address_prefixes_2" {
  type = string
}

variable "subnet_private_address_prefixes_2" {
  type = string
}

variable "default_tags" {
  type = map(string)
}

variable "stage_name" {
  type = string
}

variable "region" {
  type = string
}

variable "virtual_network_address_space" {
  type = string
}

variable "main_subnet_application_address_prefixes" {
  type = string
}

variable "subnet_data_address_1_prefixes" {
  type = string
}

variable "subnet_data_address_2_prefixes" {
  type = string
}

variable "default_tags" {
  type = map(string)
}

variable "stage_name" {
  type = string
}

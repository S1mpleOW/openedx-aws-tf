variable "location" {
  type    = string
  default = "Singapore"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "default_tags" {
  type = map(string)
  default = {
    environment = "development"
    region      = "ap-southeast-1"
    location    = "Singapore"
  }
}

variable "mysql_password" {
  type = string
  validation {
    condition     = length(var.mysql_password) > 8
    error_message = "Password must be at least 8 characters long"
  }
}

variable "stage_name" {
  type    = string
  default = "dev"
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

variable "doc_db_password" {
  description = "The password for the DocumentDB cluster"
  type        = string
}

variable "stage_name" {
  type = string
}

variable "default_tags" {
  type = map(string)
}

variable "default_cache_policy_id" {
  type = string
}

variable "default_origin_request_id" {
  type = string
}

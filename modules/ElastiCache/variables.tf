variable "redis_sg_id" {
  type = string
}

variable "node_type" {
  type = string

}

variable "tags" {
  type = map(string)
}

variable "subnet_id" {
  type = string
}

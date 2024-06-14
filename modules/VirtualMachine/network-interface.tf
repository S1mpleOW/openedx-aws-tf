# resource "aws_network_interface" "database-mongodb-nic" {
#   subnet_id       = var.subnet_id_private
#   private_ips     = ["172.31.25.255"]
#   security_groups = [var.mongodb_sg_id]

#   attachment {
#     instance     = aws_instance.mongodb_instance.id
#     device_index = 1
#   }

#   tags = merge(var.default_tags, {
#     created-date : "2024-05-30"
#     Name         : format("nic-database-mongodb-%s", var.stage_name)
#   })
# }

resource "aws_iam_instance_profile" "cloudwatch_agent_instance_profile" {
  name = "CloudWatchAgentInstanceProfile"
  role = var.aws_cloudwatch_agent_profile_role_name
}

resource "aws_instance" "openedx_instance" {
  ami           = var.openedx_ami  # Replace with your desired AMI ID
  instance_type = "t3a.large"
  key_name      = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_agent_instance_profile.name


  root_block_device {
    volume_size = 25
    volume_type = "gp2"
  }

  subnet_id = var.subnet_id_public
  security_groups = [var.edx_sg_id]

  user_data = templatefile("${path.module}/scripts/install_cw_agent.sh", {
    ec2_log_group_name = var.ec2_log_group_name
  })

  tags = merge(var.default_tags, {
    created_date: "2024-05-29"
    Name         : format("openedx_instance-%s", var.stage_name)
  })
}

resource "aws_instance" "mongodb_instance" {
  ami           = var.mongodb_ami
  instance_type = "t2.small"
  key_name      = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  subnet_id = var.subnet_id_private
  security_groups = [var.mongodb_sg_id]

  tags = merge(var.default_tags, {
    created_date: "2024-05-29"
    Name         : format("mongodb_instance-%s", var.stage_name)
  })
}

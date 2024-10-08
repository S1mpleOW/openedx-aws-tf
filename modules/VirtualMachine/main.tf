resource "aws_iam_instance_profile" "cloudwatch_agent_instance_profile" {
  name = "CloudWatchAgentInstanceProfile"
  role = var.aws_cloudwatch_agent_profile_role_name
}

data "template_file" "user_data" {
  template = filebase64("${path.module}/scripts/setup_tutor_configuration.sh")
  vars = {
    MONGODB_HOST       = "${var.MONGODB_HOST}"
    MONGODB_USERNAME   = "${var.MONGODB_USERNAME}"
    MONGODB_PASSWORD   = "${var.MONGODB_PASSWORD}"
    MYSQL_HOST         = "${var.MYSQL_HOST}"
    MYSQL_ROOT_USERNAME = "${var.MYSQL_ROOT_USERNAME}"
    MYSQL_ROOT_PASSWORD = "${var.MYSQL_ROOT_PASSWORD}"
    REDIS_HOST         = "${var.REDIS_HOST}"
    SMTP_HOST          = "${var.SMTP_HOST}"
    SMTP_USERNAME      = "${var.SMTP_USERNAME}"
    SMTP_PASSWORD      = "${var.SMTP_PASSWORD}"
    OPENEDX_AWS_ACCESS_KEY = "${var.OPENEDX_AWS_ACCESS_KEY}"
    OPENEDX_AWS_SECRET_ACCESS_KEY = "${var.OPENEDX_AWS_SECRET_ACCESS_KEY}"
    S3_REGION          = "${var.S3_REGION}"
    S3_STORAGE_BUCKET  = "${var.S3_STORAGE_BUCKET}"
    S3_PROFILE_IMAGE_BUCKET = "${var.S3_PROFILE_IMAGE_BUCKET}"
    ELASTICSEARCH_HOST = "${var.ELASTICSEARCH_HOST}"
  }
}

resource "aws_instance" "openedx_instance" {
  ami           = var.openedx_ami  # Replace with your desired AMI ID
  instance_type = "t3a.large"
  key_name      = var.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_agent_instance_profile.name
  depends_on = [ aws_iam_instance_profile.cloudwatch_agent_instance_profile]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  subnet_id = var.subnet_id_application
  vpc_security_group_ids = [var.edx_sg_id]

  user_data  = data.template_file.user_data.rendered

  tags = merge(var.default_tags, {
    created_date: "2024-05-29"
    Name         : format("openedx_instance-%s", var.stage_name)
  })
}

# resource "aws_eip" "openedx_instance" {
#   instance = aws_instance.openedx_instance.id
#   domain   = "vpc"
# }

resource "aws_instance" "mongodb_instance" {
  ami           = var.mongodb_ami
  instance_type = "t2.small"
  key_name      = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  subnet_id = var.subnet_id_database
  vpc_security_group_ids = [var.mongodb_sg_id]

  tags = merge(var.default_tags, {
    created_date: "2024-05-29"
    Name         : format("mongodb_instance-%s", var.stage_name)
  })
}

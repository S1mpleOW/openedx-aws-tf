resource "aws_elasticsearch_domain" "fastai_es" {
  domain_name           = var.domain
  elasticsearch_version  = "7.10"
  cluster_config {
    instance_type = "t3.small.elasticsearch"
    instance_count = 1
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 30
    volume_type = "gp3"
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  vpc_options {
    subnet_ids = [
      var.subnet_id
    ]
    security_group_ids = [
      var.es_sg_id
    ]
  }

  tags = var.default_tags
}

resource "aws_elasticsearch_domain_policy" "fastai_es_policy" {
  domain_name = aws_elasticsearch_domain.fastai_es.domain_name

  access_policies = <<POLICIES
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "es:*",
              "Principal": {
                "AWS": "*"
              },
              "Effect": "Allow",
              "Resource": "${aws_elasticsearch_domain.fastai_es.arn}/*"
          }
      ]
  }
  POLICIES
}

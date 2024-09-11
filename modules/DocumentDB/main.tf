data aws_kms_alias rds {
  name = "alias/aws/rds"
}

resource "aws_docdb_cluster" "openedx_cluster" {
  cluster_identifier = "openedx-docdb-cluster-${var.stage}"
  availability_zones = var.availability_zones
  master_username    = "openedx"
  master_password    = var.doc_db_password
  db_subnet_group_name = aws_docdb_subnet_group.openedx_doc_db_sg.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.openedx_docdb_cluster_pg.name
  vpc_security_group_ids = var.vpc_sg_ids
  skip_final_snapshot             = true
  kms_key_id = data.aws_kms_alias.rds.target_key_arn
  storage_encrypted = true
  tags = merge(
    var.tags,
    {
      Name = "openedx-docdb-cluster-${var.stage}"
    }
  )
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "openedx-docdb-cluster-${count.index}-${var.stage}"
  cluster_identifier = aws_docdb_cluster.openedx_cluster.id
  instance_class     = "db.t3.medium"
  tags = merge(
    var.tags,
    {
      Name = "openedx-docdb-cluster-${count.index}-${var.stage}"
    }
  )
}

resource "aws_docdb_subnet_group" "openedx_doc_db_sg" {
  name       = "openedx-docdb-subnet-group-${var.stage}"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "openedx-docdb-subnet-group"
    }
  )
}

resource "aws_docdb_cluster_parameter_group" "openedx_docdb_cluster_pg" {
  family      = "docdb5.0"
  name        = "openedx-cluster-parameter-group"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

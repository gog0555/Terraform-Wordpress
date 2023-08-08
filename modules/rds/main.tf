resource "aws_security_group" "rdssg" {
  name        = "allow_ec2sg"
  description = "Allow from ec2 instance security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "from ec2sg"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2sg_id]
  }

  egress {
    description = "to ec2sg"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.name}-db-sg"
  }
}

resource "aws_db_subnet_group" "dbsubnetgroup" {
  subnet_ids = [var.public_subnets[0], var.public_subnets[1]]

  tags = {
    Name = "${var.env}-${var.name}-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "dbparametergroup" {
  name   = "${var.env}-${var.name}-rds-pg"
  family = "${var.db_engine}${var.db_engine_version}"

  parameter {
    name  = "character_set_server"
    value = "${var.db_param_character}"
  }

  parameter {
    name  = "character_set_client"
    value = "${var.db_param_character}"
  }
}

resource "aws_db_instance" "dbinstance" {
  allocated_storage    = var.db_storage
  storage_type = var.db_storage_type
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  username             = var.db_username
  password             = var.db_password
  multi_az     = var.db_multi_az
  parameter_group_name = aws_db_parameter_group.dbparametergroup.name
  skip_final_snapshot  = true

  snapshot_identifier = var.db_snapshot_identifier

  db_subnet_group_name = aws_db_subnet_group.dbsubnetgroup.name

  vpc_security_group_ids = [aws_security_group.rdssg.id]
}
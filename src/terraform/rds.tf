# EC2 Security Group for RDS
resource "aws_security_group" "database_security_group" {
  name        = "database-sg"
  description = "Allow PostgreSQL traffic from application security group"
  vpc_id      = aws_vpc.csye6225_vpc.id

  # Ingress rule to allow PostgreSQL access
  ingress {
    description     = "Allow PostgreSQL from app security group"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.application_security_group.id]
  }

  # Egress - allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security Group "
  }
}

# RDS Parameter Group
resource "aws_db_parameter_group" "postgresql_params" {
  name        = "postgresql-params"
  family      = "postgres16"
  description = "Custom parameter group for PostgreSQL"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "csye-rds-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private[*] : subnet.id]

  tags = {
    Name = "csye-rds-subnet-group"
  }
}


# RDS Instance
resource "aws_db_instance" "csye6225_rds" {
  identifier        = "csye6225"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = "16.3"
  instance_class    = "db.t3.small"
  #Database configuration
  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result
  kms_key_id             = aws_kms_key.rds_kms.arn
  storage_encrypted      = true

  parameter_group_name   = aws_db_parameter_group.postgresql_params.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false
  multi_az               = false

  skip_final_snapshot = true

  tags = {
    Name = "csye6225-rds-instance"
  }
}
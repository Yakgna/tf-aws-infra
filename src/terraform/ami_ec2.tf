resource "aws_security_group" "application_security_group" {
  name        = "csye6225_sg"
  description = "Security group for web applications"
  vpc_id      = aws_vpc.csye6225_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_22
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_80
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_443
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_8080
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CSYE 6225 Security Group"
  }
}

resource "aws_instance" "web_app_instance" {
  ami                    = var.ami_id
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.application_security_group.id]
  subnet_id              = aws_subnet.public[0].id

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  disable_api_termination = false

  # Attach IAM role for use with CloudWatch Agent
  iam_instance_profile = aws_iam_instance_profile.csye6225_cwagent_profile.name

  user_data = templatefile("./user_data.sh", {
    DB_HOST     = aws_db_instance.csye6225_rds.address
    DB_PORT     = aws_db_instance.csye6225_rds.port
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_NAME     = var.db_name
    PORT        = var.port
    DATABASE    = aws_db_instance.csye6225_rds.db_name
  })

  tags = {
    Name = "Webapp Instance"
  }
}
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

  user_data = <<-EOF
    #!/bin/bash
    echo "DB_HOST=${aws_db_instance.csye6225_rds.address}" >> /opt/webapp/backend/.env
    echo "DB_PORT=${aws_db_instance.csye6225_rds.port}" >> /opt/webapp/backend/.env
    echo "DB_USERNAME=${var.db_username}" >> /opt/webapp/backend/.env
    echo "DB_PASSWORD=${var.db_password}" >> /opt/webapp/backend/.env
    echo "DB_NAME=${var.db_name}" >> /opt/webapp/backend/.env
    echo "PORT=${var.port}" >> /opt/webapp/backend/.env
    echo "DATABASE=${aws_db_instance.csye6225_rds.db_name}" >> /opt/webapp/backend/.env

    #Give required permissions
    sudo chown -R csye6225:csye6225 /opt/webapp/backend/.env
  EOF

  tags = {
    Name = "Webapp Instance"
  }
}
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
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
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

# Load Balancer Security Group
resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_sg"
  description = "Security group for Load balancer"
  vpc_id      = aws_vpc.csye6225_vpc.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Load Balancer Security Group"
  }
}

# Launch Template
resource "aws_launch_template" "web_app_template" {
  name = "csye6225_asg_template"

  image_id      = var.ami_id
  instance_type = "t2.small"

  iam_instance_profile {
    name = aws_iam_instance_profile.csye6225_iam_profile.name
  }
  #   security_group_names = [aws_security_group.application_security_group.name]
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.application_security_group.id]
    delete_on_termination       = true
  }

  user_data = base64encode(templatefile("./user_data.sh", {
    DB_HOST        = aws_db_instance.csye6225_rds.address
    DB_PORT        = aws_db_instance.csye6225_rds.port
    DB_USERNAME    = var.db_username
    DB_PASSWORD    = var.db_password
    DB_NAME        = var.db_name
    PORT           = var.port
    DATABASE       = aws_db_instance.csye6225_rds.db_name
    S3_BUCKET_NAME = aws_s3_bucket.csye6225_bucket.bucket
    AWS_REGION     = var.region
  }))
}
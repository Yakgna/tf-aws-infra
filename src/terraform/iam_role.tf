# IAM Role for CloudWatch Agent
resource "aws_iam_role" "csye6225_ec2_role" {
  name = "csye6225-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "csye6225_iam_policy" {
  name        = "csye6225-iam-policy"
  description = "Policy for CloudWatch agent and S3 access"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeTags",
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::csye6255-b2e80959-7f0d-4f2d-90de-ac9fe246b050/*"
      }
    ]
  })
}

# Attach CloudWatch Agent policy
resource "aws_iam_role_policy_attachment" "csye6225_role_policy_attach" {
  role       = aws_iam_role.csye6225_ec2_role.name
  policy_arn = aws_iam_policy.csye6225_iam_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "csye6225_iam_profile" {
  name = "csye6225-iam-profile"
  role = aws_iam_role.csye6225_ec2_role.name
}
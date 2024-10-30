# IAM Role for CloudWatch Agent
resource "aws_iam_role" "csye6225_cwagent_role" {
  name = "csye6225-cwagent-role"

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

resource "aws_iam_policy" "cw_agent_policy" {
  name        = "CloudWatchAgentPolicy"
  description = "Policy for CloudWatch agent to access logs and metrics"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "cloudwatch:PutMetricData"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Attach CloudWatch Agent policy
resource "aws_iam_role_policy_attachment" "csye6225_cwagent_policy" {
  role       = aws_iam_role.csye6225_cwagent_role.name
  policy_arn = aws_iam_policy.cw_agent_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "csye6225_cwagent_profile" {
  name = "csye6225-cwagent-profile"
  role = aws_iam_role.csye6225_cwagent_role.name
}
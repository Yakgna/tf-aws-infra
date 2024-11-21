# SNS Topic
resource "aws_sns_topic" "user_verification_topic" {
  name = "user_verification_topic"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "email_verification_policy" {
  name        = "email_verification_lambda_policy"
  description = "Policy for email verification Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds-data:ExecuteStatement",
          "rds-data:BatchExecuteStatement",
          "rds:DescribeDBInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish",
          "sns:Subscribe"
        ]
        Resource = aws_sns_topic.user_verification_topic.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policies" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.email_verification_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "email_verification_lambda" {
  filename      = "lambda.zip"
  function_name = "email_verification_function"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda.handler"
  runtime       = "nodejs20.x"
  environment {
    variables = {
      SENDGRID_API_KEY = var.send_grid_api_key
      DB_PORT          = aws_db_instance.csye6225_rds.port
      PORT             = var.app_port
      DB_USERNAME      = var.db_username
      DB_PASSWORD      = var.db_password
      DATABASE         = aws_db_instance.csye6225_rds.db_name
      DB_HOST          = aws_db_instance.csye6225_rds.address
      ENVIRONMENT      = var.profile
      DOMAIN_NAME      = var.domain_name
    }
  }
  depends_on = [aws_iam_role_policy_attachment.attach_lambda_policies]
}

# Trigger Lambda from SNS
resource "aws_sns_topic_subscription" "lambda_trigger" {
  topic_arn = aws_sns_topic.user_verification_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_verification_lambda.arn
}

# Lambda Function Permission for SNS
resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_verification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.user_verification_topic.arn
}
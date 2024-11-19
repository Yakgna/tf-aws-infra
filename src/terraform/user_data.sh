#!/bin/bash
echo "DB_HOST=${DB_HOST}" >> /opt/webapp/backend/.env
echo "DB_PORT=${DB_PORT}" >> /opt/webapp/backend/.env
echo "DB_USERNAME=${DB_USERNAME}" >> /opt/webapp/backend/.env
echo "DB_PASSWORD=${DB_PASSWORD}" >> /opt/webapp/backend/.env
echo "DB_NAME=${DB_NAME}" >> /opt/webapp/backend/.env
echo "PORT=${PORT}" >> /opt/webapp/backend/.env
echo "DATABASE=${DATABASE}" >> /opt/webapp/backend/.env
echo "S3_BUCKET_NAME=${S3_BUCKET_NAME}" >> /opt/webapp/backend/.env
echo "AWS_REGION=${AWS_REGION}" >> /opt/webapp/backend/.env
echo "SNS_TOPIC_ARN=${SNS_TOPIC_ARN}" >> /opt/webapp/backend/.env

#Give required permissions
sudo chown -R csye6225:csye6225 /opt/webapp/backend/.env

# Start the CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
# Start CloudWatch Agent on boot
sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent

# Restart CSYE6225
sudo systemctl daemon-reload
sudo systemctl restart csye6225
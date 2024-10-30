cat << EOF |
    #!/bin/bash
    echo "DB_HOST=${DB_HOST}" >> /opt/webapp/backend/.env
    echo "DB_PORT=${DB_PORT}" >> /opt/webapp/backend/.env
    echo "DB_USERNAME=${DB_USERNAME}" >> /opt/webapp/backend/.env
    echo "DB_PASSWORD=${DB_PASSWORD}" >> /opt/webapp/backend/.env
    echo "DB_NAME=${DB_NAME}" >> /opt/webapp/backend/.env
    echo "PORT=${PORT}" >> /opt/webapp/backend/.env
    echo "DATABASE=${DATABASE}" >> /opt/webapp/backend/.env
EOF

#Give required permissions
sudo chown -R csye6225:csye6225 /opt/webapp/backend/.env

# Create CloudWatch Agent configuration
cat << EOF | sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
    "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "csye6225",
        "logfile": "/var/log/amazon-cloudwatch-agent.log"
    },
    "metrics": {
        "namespace": "MyApp/CustomMetrics",
        "metrics_collected": {
          "statsd": {
            "metrics_aggregation_interval": 10,
            "metrics_collection_interval": 10,
            "service_address": ":8125"
          }
        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/messages",
                        "log_group_name": "csye6225-logs",
                        "log_stream_name": "csye6225-stream"
                    }
                ]
            }
        }
    }
}
EOF

# Start the CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a start \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s
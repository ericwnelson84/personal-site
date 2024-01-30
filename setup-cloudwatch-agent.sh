#!/bin/bash

# Define CloudWatch Agent configuration file path
CW_AGENT_CONFIG_FILE="/opt/aws/amazon-cloudwatch-agent/bin/config.json"

# Function to install CloudWatch Agent on Amazon Linux
install_on_amazon_linux() {
    echo "Installing CloudWatch Agent on Amazon Linux..."
    sudo yum install -y amazon-cloudwatch-agent
}

# Function to install CloudWatch Agent on Ubuntu
install_on_ubuntu() {
    echo "Installing CloudWatch Agent on Ubuntu..."
    wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
}

# Detect OS and install CloudWatch Agent
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        amazon) install_on_amazon_linux ;;
        ubuntu) install_on_ubuntu ;;
        *) echo "Unsupported distribution: $ID" ;;
    esac
else
    echo "Cannot detect OS distribution."
    exit 1
fi

# Check if the CloudWatch Agent configuration file exists
if [ ! -f "$CW_AGENT_CONFIG_FILE" ]; then
    echo "CloudWatch Agent configuration file does not exist. Creating a default one..."
    # Create a default configuration file
    cat <<EOF >"$CW_AGENT_CONFIG_FILE"
{
    "agent": {
        "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/syslog",
                        "log_group_name": "your-log-group-name",
                        "log_stream_name": "{instance_id}",
                        "timezone": "Local"
                    }
                ]
            }
        }
    }
}
EOF
fi

# Start the CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:"$CW_AGENT_CONFIG_FILE" -s
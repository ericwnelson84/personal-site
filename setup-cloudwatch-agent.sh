#!/usr/bin/env python3

import os
import subprocess
import json

# CloudWatch Agent configuration
cw_agent_config = {
    "agent": {
        "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/uwsgi/uwsgi.log",
                        "log_group_name": "blog-EC2-uwsgi-logs",
                        "log_stream_name": "{instance_id}",
                        "timezone": "Local"
                    }
                ]
            }
        }
    }
}
config_file_path = "/opt/aws/amazon-cloudwatch-agent/bin/config.json"

# Function to execute shell commands
def run_command(command):
    try:
        subprocess.run(command, check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}\n{e}")
        return False

# Function to install CloudWatch Agent based on OS
def install_cw_agent():
    if os.path.isfile("/etc/os-release"):
        with open("/etc/os-release") as f:
            os_release = f.read()
        if 'ID="amzn"' in os_release:
            print("Amazon Linux detected. Installing CloudWatch Agent...")
            return run_command("sudo yum install -y amazon-cloudwatch-agent")
        elif 'ID=ubuntu' in os_release:
            print("Ubuntu detected. Installing CloudWatch Agent...")
            return run_command("wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb && sudo dpkg -i -E ./amazon-cloudwatch-agent.deb")
        else:
            print("Unsupported distribution.")
            return False
    else:
        print("Cannot detect OS distribution.")
        return False

# Function to create CloudWatch Agent configuration file
def create_cw_agent_config():
    print("Creating CloudWatch Agent configuration file...")
    with open(config_file_path, 'w') as config_file:
        json.dump(cw_agent_config, config_file, indent=4)

# Function to start the CloudWatch Agent
def start_cw_agent():
    print("Starting the CloudWatch Agent...")
    print(f"config file path: {config_file_path}")
    return run_command(f"sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:{config_file_path} -s")

# Main function
def main():
    if install_cw_agent():
        create_cw_agent_config()
        if start_cw_agent():
            print("CloudWatch Agent setup completed successfully.")
        else:
            print("Failed to start the CloudWatch Agent.")
    else:
        print("Failed to install the CloudWatch Agent.")

if __name__ == "__main__":
    main()
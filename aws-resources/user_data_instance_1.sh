#!/bin/bash
# Log file for debugging
LOG_FILE="/tmp/user_data.log"
exec >$LOG_FILE 2>&1

echo "Starting user_data script"

# Update system
sudo apt update -y
sudo apt install -y software-properties-common

# Add Ansible repository
sudo apt-add-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt install ansible-core -y
sudo apt install -y ansible

echo "user_data script completed"

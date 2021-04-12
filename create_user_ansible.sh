#!/bin/bash

# Add your key.pub here
KEY=""

# Create ansible user/group
sudo addgroup ansible
sudo adduser --disabled-password --shell /bin/bash --gecos "ansible" --ingroup sudo --ingroup ansible ansible
# Add user ansible to sudoers
echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/ansible
# Configure ssh connection
sudo mkdir -p /home/ansible/.ssh/
echo "$KEY" | sudo tee -a /home/ansible/.ssh/authorized_keys
sudo chown -R ansible.ansible /home/ansible/.ssh
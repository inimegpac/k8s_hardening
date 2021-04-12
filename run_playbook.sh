#!/bin/bash

# Deploy a playbook passing it as argument
PLAYBOOK=$1
ansible-playbook -v $PLAYBOOK

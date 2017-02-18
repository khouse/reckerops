#!/usr/bin/env bash
# bootstrap.sh
DEBIAN_FRONTEND=noninteractive

# Make the docker config directory
sudo mkdir -p /reckerops/{proxy,app} && sudo chown -R admin:admin /reckerops/

# Install Dependencies
sudo apt-get -y update && \
    sudo apt-get install -y apt-transport-https ca-certificates \
	 curl software-properties-common python-pip

# Download docker key
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -

# Add Docker Repository
sudo add-apt-repository "deb https://apt.dockerproject.org/repo/ debian-$(lsb_release -cs) main"

# Install docker and docker-compose
sudo apt-get update && \
    sudo apt-get install -y docker-engine && \
    sudo pip install docker-compose

# Verify executables exist
which docker && which docker-compose

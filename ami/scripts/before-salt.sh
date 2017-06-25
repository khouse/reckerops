#!/usr/bin/env bash
apt-get update && apt-get dist-upgrade -y
apt-get install -y python-pip && pip install --upgrade pip

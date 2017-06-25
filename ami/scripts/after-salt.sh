#!/usr/bin/env bash
apt-get purge -y salt-* && apt-get autoremove -y
rm -rf /etc/apt/sources.list.d/saltstack.list
apt-get update

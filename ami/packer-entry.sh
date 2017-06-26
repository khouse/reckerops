#!/usr/bin/env bash
sed -i "s/OVERWRITE_THIS_PASSWORD/$ROOT_PASSWORD_HASH/g" pillar/password.sls
packer validate packer.json && packer build -force packer.json

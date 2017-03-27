#!/usr/bin/env bash
echo '-----BEGIN RSA PRIVATE KEY-----' > ~/.ssh/reckerops-build.pem
echo $RECKEROPS_BUILD_SSH_PRIVATE_KEY | fold -w 72 >> ~/.ssh/reckerops-build.pem
echo '-----END RSA PRIVATE KEY-----' >> ~/.ssh/reckerops-build.pem

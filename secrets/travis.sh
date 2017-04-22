#!/usr/bin/env bash
# Generate secrets from environment variables
HERE=$(dirname "$0")

# aws.env
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> $HERE/aws.env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> $HERE/aws.env

# build.pem
echo '-----BEGIN RSA PRIVATE KEY-----' > $HERE/build.pem
echo $RECKEROPS_BUILD_SSH_PRIVATE_KEY | fold -w 72 >> $HERE/build.pem
echo '-----END RSA PRIVATE KEY-----' >> $HERE/build.pem

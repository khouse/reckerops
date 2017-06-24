#!/usr/bin/env bash
# Generate secrets from environment variables

HERE=$(dirname "$0")

# aws.env
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" > $HERE/aws.env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> $HERE/aws.env
echo "AWS_DEFAULT_REGION=us-west-2" >> $HERE/aws.env

# cloudflare.env
echo "CLOUDFLARE_API_KEY=$CLOUDFLARE_API_KEY" > $HERE/cloudflare.env
echo "CLOUDFLARE_EMAIL=alex@reckerfamily.com" >> $HERE/cloudflare.env

# kitchen.pem
echo '-----BEGIN RSA PRIVATE KEY-----' > $HERE/kitchen.pem
echo $RECKEROPS_KITCHEN_PRIVATE_SSH_KEY | fold -w 72 >> $HERE/kitchen.pem
echo '-----END RSA PRIVATE KEY-----' >> $HERE/kitchen.pem

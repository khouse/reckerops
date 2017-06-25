#!/usr/bin/env bash
# Populate secret environment files.  When running in local dev, get
# them from pass.  Otherwise, assume it's exported as an environment
# variable.

HERE=$(dirname "$0")

if [ "$1" == "local" ]; then
    AWS_ACCESS_KEY_ID="$(pass reckerops/aws_access_key_id)"
    AWS_SECRET_ACCESS_KEY="$(pass reckerops/aws_secret_access_key)"
    CLOUDFLARE_API_KEY="$(pass reckerops/cloudflare_api_key)"
    KITCHEN_SSH_PRIVATE_KEY="$(pass reckerops/kitchen_ssh_private_key)"
fi

# aws.env
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" > $HERE/aws.env
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> $HERE/aws.env
echo "AWS_DEFAULT_REGION=us-west-2" >> $HERE/aws.env

# cloudflare.env
echo "CLOUDFLARE_API_KEY=$CLOUDFLARE_API_KEY" > $HERE/cloudflare.env
echo "CLOUDFLARE_EMAIL=alex@reckerfamily.com" >> $HERE/cloudflare.env

# kitchen.pem
echo '-----BEGIN RSA PRIVATE KEY-----' > $HERE/kitchen.pem
echo $KITCHEN_SSH_PRIVATE_KEY | fold -w 72 >> $HERE/kitchen.pem
echo '-----END RSA PRIVATE KEY-----' >> $HERE/kitchen.pem

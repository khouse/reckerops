#!/usr/bin/env bash
# Generate secrets from environment variables

HERE=$(dirname "$0")
SECRETS=$HERE/secrets.env

# secrets.env
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> $SECRETS
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> $SECRETS
echo "CLOUDFLARE_API_KEY=$CLOUDFLARE_API_KEY" >> $SECRETS

# build.pem
echo '-----BEGIN RSA PRIVATE KEY-----' > $HERE/build.pem
echo $RECKEROPS_BUILD_SSH_PRIVATE_KEY | fold -w 72 >> $HERE/build.pem
echo '-----END RSA PRIVATE KEY-----' >> $HERE/build.pem

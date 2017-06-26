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
    DIGITALOCEAN_API_TOKEN="$(pass reckerops/digitalocean_api_token)"
    ROOT_PASSWORD_HASH="$(pass reckerops/root_password_hash)"
    STRONGBADIA_MYSQL_ROOT_PASSWORD="$(pass reckerops/strongbadia/mysql_root_password)"
    STRONGBADIA_MYSQL_DATABASE="$(pass reckerops/strongbadia/mysql_database)"
    STRONGBADIA_MYSQL_USER="$(pass reckerops/strongbadia/mysql_user)"
    STRONGBADIA_MYSQL_PASSWORD="$(pass reckerops/strongbadia/mysql_password)"
    STRONGBADIA_WORDPRESS_DB_NAME="$(pass reckerops/strongbadia/wordpress_db_name)"
    STRONGBADIA_WORDPRESS_DB_USER="$(pass reckerops/strongbadia/wordpress_db_user)"
    STRONGBADIA_WORDPRESS_DB_PASSWORD="$(pass reckerops/strongbadia/wordpress_db_password)"
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

# digitalocean.env
echo "DIGITALOCEAN_API_TOKEN=$DIGITALOCEAN_API_TOKEN" > $HERE/digitalocean.env

# rootpassword.env
echo "ROOT_PASSWORD_HASH=$ROOT_PASSWORD_HASH" > $HERE/rootpassword.env

# strongbadia.env
echo "STRONGBADIA_MYSQL_ROOT_PASSWORD=$STRONGBADIA_MYSQL_ROOT_PASSWORD" > $HERE/strongbadia.env
echo "STRONGBADIA_MYSQL_DATABASE=$STRONGBADIA_MYSQL_DATABASE" >> $HERE/strongbadia.env
echo "STRONGBADIA_MYSQL_USER=$STRONGBADIA_MYSQL_USER" >> $HERE/strongbadia.env
echo "STRONGBADIA_MYSQL_PASSWORD=$STRONGBADIA_MYSQL_PASSWORD" >> $HERE/strongbadia.env
echo "STRONGBADIA_WORDPRESS_DB_NAME=$STRONGBADIA_WORDPRESS_DB_NAME" >> $HERE/strongbadia.env
echo "STRONGBADIA_WORDPRESS_DB_USER=$STRONGBADIA_WORDPRESS_DB_USER" >> $HERE/strongbadia.env
echo "STRONGBADIA_WORDPRESS_DB_PASSWORD=$STRONGBADIA_WORDPRESS_DB_PASSWORD" >> $HERE/strongbadia.env

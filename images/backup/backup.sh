#!/usr/bin/env bash

: "${BUCKET_NAME?Need to set BUCKET_NAME}"
: "${AWS_REGION?Need to set AWS_REGION}"
: "${AWS_ACCESS_KEY_ID?Need to set AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY?Need to set AWS_SECRET_ACCESS_KEY}"

timestamp="$(date +%s)"

cd /data || exit

for key in *; do
    target="$key-$timestamp.tar.gz"
    tar -zpcvf "$target" "$key"
    aws s3 cp "$target" "s3://${BUCKET_NAME}/${key}/${target}" && rm "$target"
done

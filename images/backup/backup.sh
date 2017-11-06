#!/usr/bin/env sh

: "${BUCKET_NAME?Need to set BUCKET_NAME}"
: "${AWS_REGION?Need to set AWS_REGION}"
: "${AWS_ACCESS_KEY_ID?Need to set AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY?Need to set AWS_SECRET_ACCESS_KEY}"

timestamp="$(date +%s)"

cd /data || exit 1

for key in *; do
    target="$key-$timestamp.tar.gz"
    destination="s3://${BUCKET_NAME}/${key}/${target}"

    echo "Compressing $key to $target"
    tar -zpcvf "$target" "$key"

    echo "Copying $target to $destination"
    aws s3 cp "$target" "$destination" && rm "$target"
done

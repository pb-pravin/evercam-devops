#!/usr/bin/env bash

s3_key=$1
s3_secret=$2
bucket=$3
path=$4
aws_path=$5

date=$(date +"%a, %d %b %Y %T %z")
acl="x-amz-acl:private"
content_type="image/jpeg"
string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path"
echo $string
signature=$(echo -en "${string}" | openssl sha1 -hmac "${s3_secret}" -binary | base64)
echo $signature
curl -X PUT -T "$path" \
     -H "Host: $bucket.s3.amazonaws.com" \
     -H "Date: $date" \
     -H "Content-Type: $content_type" \
     -H "$acl" \
     -H "Authorization: AWS ${s3_key}:$signature" \
     "https://$bucket.s3.amazonaws.com$aws_path"

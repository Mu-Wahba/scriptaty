#!/bin/bash


#Open s3_public_Objects.txt to list all object keys to be public check S3-GetAllFilesWithPublicACL.sh script to generate it if needed.
# Then process in parallel based on available cpu e.g -P25 25 at a time

cat s3_public_Objects.txt | xargs -P25 -I{} bash -c '
  BUCKET_NAME=
  REGION=
  key="{}"
  aws s3api put-object-acl --bucket "$BUCKET_NAME" --region "$REGION" --key "$key" --acl public-read
  #print object key and add it to file
  echo "$key"
  echo "$key" >> s3_completed_public_objects.txt
  '

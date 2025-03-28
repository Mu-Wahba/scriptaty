#!/bin/bash

BUCKET_NAME=
REGION=

#Get all object Keys
aws s3api list-objects --bucket "$BUCKET_NAME" --region "$REGION" --query "Contents[].Key" --output text | tr '\t' '\n' > s3_object_keys.txt

# Then process in parallel based on available cpu e.g 25 at a time

cat s3_object_keys.txt | xargs -P25 -I{} bash -c '
  BUCKET_NAME=
  REGION=
  key="{}"
  acl=$(aws s3api get-object-acl --bucket "$BUCKET_NAME" --key "$key" \
        --region "$REGION" --output text)
  if echo "$acl" | grep -q "AllUsers"; then
  #print object key and add to s3_public_Objects.txt
    echo "$key is set to public"
    echo "$key" >> s3_public_Objects.txt
  else
          #print private files as well if needed
          echo "$key ------------------------------------- is not public"
fi
  '

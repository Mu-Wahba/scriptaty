#!/bin/bash

# List all buckets
buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# Loop through each bucket and get its region
echo "Listing all buckets with their regions:"
for bucket in $buckets; do
    # Get the region of the bucket
    region=$(aws s3api get-bucket-location --bucket "$bucket" --query "LocationConstraint" --output text)

    # If region is null, it means the bucket is in us-east-1
    if [[ "$region" == "None" ]]; then
        region="us-east-1"
    fi

    echo "Bucket: $bucket, Region: ${region:-us-east-1}"
done

#!/bin/bash

exclude_buckets=("bucket-1" "bucket-2")


for bucket in $all_buckets; do
    if [[ ! " ${exclude_buckets[@]} " =~ " ${bucket} " ]]; then
        echo "Fetching region for bucket: $bucket"

        # Get the region of the bucket
        bucket_region=$(aws s3api get-bucket-location --bucket $bucket --query 'LocationConstraint' --output text)

        # If the region is None (for us-east-1), set it explicitly
        if [ "$bucket_region" == "None" ]; then
            bucket_region="us-east-1"
        fi

        # Disable logging for the bucket in its region
        echo "Disabling logging for bucket: $bucket in region: $bucket_region"
        aws s3api put-bucket-logging --bucket $bucket --bucket-logging-status '{}' --region $bucket_region
    else
        echo "Skipping bucket (keeping logging enabled): $bucket"
    fi
done

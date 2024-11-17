#!/bin/bash

# Specify the desired region
desired_region="eu-west-1"

#Logging bucket
LOGGING_BUCKET="bucket-s3-access-logs" #MUST be in the same region

# List all buckets
buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

# Loop through each bucket and get its region
for bucket in $buckets; do
    # Get the region of the bucket
    region=$(aws s3api get-bucket-location --bucket "$bucket" --query "LocationConstraint" --output text)

    # If region is null, it means the bucket is in us-east-1
    if [[ "$region" == "None" ]]; then
        region="us-east-1"
    fi

    # Check if the region matches the desired region
    if [[ "$region" == "$desired_region" ]]; then

      if [[ "$bucket" != "$LOGGING_BUCKET" ]]; then
         echo "Enabling logging for bucket: $bucket"

         # Set the logging configuration for each bucket
         aws s3api put-bucket-logging --region eu-west-1 --bucket "$bucket" --bucket-logging-status \
         "{\"LoggingEnabled\": {\"TargetBucket\": \"$LOGGING_BUCKET\", \"TargetPrefix\": \"$bucket/\"}}"
	 #Logs are in LOGGING_BUCKET/BUCKETNAME/
     fi
    fi
done

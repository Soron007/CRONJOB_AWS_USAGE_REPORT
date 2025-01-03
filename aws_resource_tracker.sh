#!/bin/bash

EMAIL="mitrasouvik123@gmail.com"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it before running this script."
    exit 1
fi

# Function to list EC2 instances
report_ec2() {
    echo "===== EC2 Instances =====" >> resourceTracker
    aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId, InstanceType, State.Name]" --output table >> resourceTracker
    echo "" >> resourceTracker
}

# Function to list S3 buckets
report_s3() {
    echo "===== S3 Buckets =====" >> resourceTracker
    aws s3 ls >> resourceTracker
    echo "" >> resourceTracker
}

# Function to list Lambda functions
report_lambda() {
    echo "===== Lambda Functions =====" >> resourceTracker
    aws lambda list-functions --query "Functions[].[FunctionName, Runtime, LastModified]" --output table >> resourceTracker
    echo "" >> resourceTracker
}

# Function to list IAM users
report_iam_users() {
    echo "===== IAM Users =====" >> resourceTracker
    aws iam list-users --query "Users[].[UserName, UserId, CreateDate]" --output table >> resourceTracker
    echo "" >> resourceTracker
}

# Function to email the report
send_email() {
    SUBJECT="AWS Resource Usage Report"
    BODY="Please find the attached AWS resource usage report."
    mail -s "$SUBJECT" "$EMAIL" < resourceTracker
}

# Main script execution
echo "AWS Resource Usage Report" > resourceTracker
echo "==========================" >> resourceTracker
report_ec2
report_s3
report_lambda
report_iam_users
send_email


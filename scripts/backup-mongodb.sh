#!/bin/bash

set -e

SNS_TOPIC_ARN="YOUR-SNS-TOPIC-ARN"

send_failure_alert() {
    ERROR_MESSAGE="$1"

    aws sns publish \
        --topic-arn "$SNS_TOPIC_ARN" \
        --subject "ALERT: MongoDB Backup Failed" \
        --message "MongoDB backup failed on $(hostname) at $(date).

Error: $ERROR_MESSAGE"
}

trap 'send_failure_alert "Backup script failed at line $LINENO"' ERR

# Configuration
CONTAINER_NAME="contact-mongodb"
BACKUP_DIR="/home/ubuntu/mongodb-backups"
S3_BUCKET="YOUR-BUCKET-NAME"

# Create timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="mongodb-backup-${TIMESTAMP}.archive"

echo "Starting MongoDB backup..."

# Create backup inside MongoDB container
sudo docker exec "$CONTAINER_NAME" mongodump \
  --archive="/tmp/$BACKUP_FILE" \
  --gzip

# Copy backup to EC2 host
sudo docker cp \
  "$CONTAINER_NAME:/tmp/$BACKUP_FILE" \
  "$BACKUP_DIR/$BACKUP_FILE"

# Upload backup to Amazon S3
echo "Uploading backup to S3..."

aws s3 cp \
  "$BACKUP_DIR/$BACKUP_FILE" \
  "s3://$S3_BUCKET/mongodb-backups/$BACKUP_FILE"

# Remove temporary backup from MongoDB container
sudo docker exec "$CONTAINER_NAME" rm "/tmp/$BACKUP_FILE"

# Delete local backups older than 7 days
echo "Cleaning up local backups older than 7 days..."

find "$BACKUP_DIR" \
  -type f \
  -name "mongodb-backup-*.archive" \
  -mtime +7 \
  -delete

echo "Backup completed and uploaded successfully!"
echo "Local backup: $BACKUP_DIR/$BACKUP_FILE"
echo "S3 backup: s3://$S3_BUCKET/mongodb-backups/$BACKUP_FILE"
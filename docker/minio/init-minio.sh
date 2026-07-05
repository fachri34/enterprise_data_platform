#!/bin/sh

set -e

echo "Waiting MinIO..."

until mc alias set myminio \
    http://minio:9000 \
    "$MINIO_ROOT_USER" \
    "$MINIO_ROOT_PASSWORD"
do
    sleep 2
done

echo "Connected."

echo "Removing old buckets..."

mc rb --force myminio/$LOGS_BUCKET || true
mc rb --force myminio/$ADV_BUCKET || true

echo "Creating buckets..."

mc mb myminio/$LOGS_BUCKET || true
mc mb myminio/$ADV_BUCKET || true

echo "Setting anonymous download policy..."

mc anonymous set download myminio/$LOGS_BUCKET
mc anonymous set download myminio/$ADV_BUCKET

echo "Finished."
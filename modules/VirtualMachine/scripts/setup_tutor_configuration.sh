#!/bin/bash
# Configure the tutor environment
tutor config save --set RUN_MONGODB=false --set MONGODB_HOST=${MONGODB_HOST}
tutor config save --set RUN_MYSQL=false --set MYSQL_HOST=${MYSQL_HOST} --set MYSQL_ROOT_USERNAME=${MYSQL_ROOT_USERNAME} --set MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
tutor config save --set RUN_REDIS=false --set REDIS_HOST=${REDIS_HOST}
tutor config save --set RUN_SMTP=false --set SMTP_HOST=${SMTP_HOST} --set SMTP_PORT=587 --set SMTP_USERNAME=${SMTP_USERNAME} --set SMTP_PASSWORD=${SMTP_PASSWORD} --set SMTP_USE_TLS=true
tutor config save --set OPENEDX_AWS_ACCESS_KEY=${OPENEDX_AWS_ACCESS_KEY} --set OPENEDX_AWS_SECRET_ACCESS_KEY=${OPENEDX_AWS_SECRET_ACCESS_KEY} --set S3_STORAGE_BUCKET=${S3_STORAGE_BUCKET} --set S3_REGION=${S3_REGION} --set S3_PROFILE_IMAGE_BUCKET=${S3_PROFILE_IMAGE_BUCKET}
tutor config save

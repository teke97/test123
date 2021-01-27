#!/bin/sh

# cd android && zip android_keys.zip .env key.jks key.properties secret.json && gpg --symmetric --cipher-algo AES256 android_keys.zip
docker run --rm -ti -v $PWD/android:/app -w /app ubuntu bash -c "ls -la && apt-get update && apt-get install -y gnupg zip && zip android_keys.zip key.jks key.properties secret.json && gpg --symmetric --cipher-algo AES256 android_keys.zip"

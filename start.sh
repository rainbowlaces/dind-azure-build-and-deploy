#!/bin/bash

# Clone the repo using the Personal Access Token
GIT_REPO_URL=https://x-access-token:$GIT_PAT_TOKEN@github.com/$REPO.git
git clone $GIT_REPO_URL /app/repo

# Set working directory to the cloned repo
cd /app/repo

# Extract the version from package.json
APP_VERSION=$(jq -r '.version' package.json)
echo "App version: $APP_VERSION"

# Set the registry login server
ACR_LOGIN_SERVER=$REGISTRY.azurecr.io

# Authenticate to ACR using Managed Identity
TOKEN=$(curl -H "Metadata:true" 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' | jq -r '.access_token')

# Login to ACR
echo $TOKEN | docker login $ACR_LOGIN_SERVER --username 00000000-0000-0000-0000-000000000000 --password-stdin

# Build the Docker image with the versioned tag
docker build -t $DOCKER_IMAGE_NAME:$APP_VERSION .

# Push the image to ACR
docker push $DOCKER_IMAGE_NAME:$APP_VERSION
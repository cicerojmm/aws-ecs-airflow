#!/usr/bin/env bash

IMAGE_NAME=$1
# create a new commit hash at each deployment
COMMIT_HASH=test_deployment

### ECR - build images and push to remote repository

echo "Building image: $IMAGE_NAME:latest"

docker build --rm -t $IMAGE_NAME:latest .

eval $(aws ecr get-login --no-include-email)

# tag and push image using latest
docker tag $IMAGE_NAME $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest
docker push $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:latest

# tag and push image with commit hash
COMMIT_HASH=your_unique_identifier
docker tag $IMAGE_NAME $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:$COMMIT_HASH
docker push $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME:$COMMIT_HASH

cd infrastructure/terraform
terraform apply -var 'image_version=$COMMIT_HASH' -auto-approve
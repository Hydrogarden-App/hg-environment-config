#!/bin/bash
set -e

# VM registry address
VM_REGISTRY="10.8.0.1:5000"

docker buildx build --push --platform linux/arm64 -t 10.8.0.1:5000/hg-backend:latest ./hydrogarden-backend
docker buildx build --platform linux/arm64 -t 10.8.0.1:5000/hg-frontend:latest ./hydrogarden-frontend
docker buildx build --platform linux/arm64 -t 10.8.0.1:5000/hg-mysql:latest ./hg-mysql
docker buildx build --platform linux/arm64 -t 10.8.0.1:5000/hg-rabbitmq:latest ./hg-rabbitmq

docker push 10.8.0.1:5000/hg-backend:latest
docker push 10.8.0.1:5000/hg-frontend:latest
docker push 10.8.0.1:5000/hg-mysql:latest
docker push 10.8.0.1:5000/hg-rabbitmq:latest


echo "All images pushed to $VM_REGISTRY successfully."

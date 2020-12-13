#!/bin/bash
# This is a template only at the moment. chiron-squeezemeta does not exist at the moment.

IMAGE_VERSION='1.0.0'

docker rmi -f chiron-squeezemeta
docker build --no-cache -t chiron-squeezemeta:latest -t chiron-squeezemeta:${IMAGE_VERSION} .
docker images

echo "If ready for release, run: "
echo "  docker push umigs/chiron-squeezemeta:latest"
echo "  docker push umigs/chiron-squeezemeta:${IMAGE_VERSION}"


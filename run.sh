#!/bin/bash

ACTION=$1
VER=${2:-4.11.0}
IMAGE_NAME="docker.io/skbcloudx/huawei-esdk-builder:debian13-go1.24.1"

usage() {
  echo "Usage: $0 [-b|-r] [options]"
  echo "  -b --build [VERSION]  Build huawei csi driver images."
  echo "  -i --image            Create a builder image."
  echo "  -r --run [VERSION]    Run and dive into the container."
  exit 1
}

if [ -z "$ACTION" ]; then
  usage
fi
mkdir -p ./output

case "$ACTION" in
  -b | --build)
    docker run --rm \
        -v /run/docker.sock:/run/docker.sock \
        -v "$(pwd)/output:/workspace/output" \
        -e HOST_UID=$(id -u) \
        -e HOST_GID=$(id -g) \
        "${IMAGE_NAME}" "${VER}"
    ;;
  -i | --image)
    docker build -t "${IMAGE_NAME}" -f scripts/Dockerfile-skb .
    ;;
  -r | --run)
    docker run --rm -it \
        -v /run/docker.sock:/run/docker.sock \
        -v "$(pwd)/output:/workspace/output" \
        -e HOST_UID=$(id -u) \
        -e HOST_GID=$(id -g) \
        --entrypoint=/bin/bash \
        "${IMAGE_NAME}"
    ;;
  *)
      echo "Error: $ACTION"
      usage
      ;;
esac

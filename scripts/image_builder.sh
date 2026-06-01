#!/bin/bash

set -e

CUR_DIR=$(dirname $0)
GIT_SRC=$(basename $GIT_URL)

VER=${1:-4.11.0}
GIT_TAG="v${VER}-skb"

if [[ ! -d "${WORKSPACE}/${GIT_SRC}" ]]; then
  git clone -b ${GIT_TAG} ${GIT_URL} ${WORKSPACE}/${GIT_SRC}
fi
cp ${CUR_DIR}/build_skb.sh ${WORKSPACE}/${GIT_SRC}/
pushd ${WORKSPACE}/${GIT_SRC}
  ./build_skb.sh ${VER}
popd
# extract the image tarballs and oceanctl binary
ZIPFILE=${WORKSPACE}/${GIT_SRC}/eSDK_Storage_CSI_V${VER}_X86_64.zip 
bsdtar -C ${WORKSPACE}/output -xvf ${ZIPFILE} -s "|.*/||" \
  "eSDK_Storage_CSI_V${VER}_X86_64/image/*.tar"
bsdtar -C ${WORKSPACE}/output -xvf ${ZIPFILE} -s "|.*/||" \
  "eSDK_Storage_CSI_V${VER}_X86_64/bin/oceanctl"

if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then
  echo "Changing file ownership to host user (${HOST_UID}:${HOST_GID})..."
  chown -R ${HOST_UID}:${HOST_GID} ${WORKSPACE}/output
else
  echo "HOST_UID and HOST_GID are not provided. Keep root ownership."
fi

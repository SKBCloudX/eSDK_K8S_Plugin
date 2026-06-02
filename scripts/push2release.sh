#!/bin/bash
#
set -e

CUR_DIR=$(dirname $0)
OUTPUT_DIR="${CUR_DIR}/../output"

BIN_NAME="${OUTPUT_DIR}/oceanctl"
TAG_VERSION="${1}"
RELEASE_TITLE="Release ${TAG_VERSION}"
RELEASE_NOTES="Add oceanctl ${TAG_VERSION} binary"

usage() {
    echo "Usage: $0 [VERSION]"
    exit 1
}
if [ -z "$TAG_VERSION" ]; then
    usage
fi

if ! command -v gh &>/dev/null; then
    echo "Abort: Cannot find gh(GitHub CLI) command."
    exit 1
fi

if ! gh auth status &>/dev/null; then
    echo "Abort: You need to log into GitHub first."
    exit 1
fi

gh repo set-default SKBCloudX/eSDK_K8S_Plugin

if [ ! -f "${BIN_NAME}" ]; then
    echo "Abort: Cannot find ${BIN_NAME}."
    exit 1
fi

gh release create "${TAG_VERSION}" "${BIN_NAME}" \
    --title "${RELEASE_TITLE}" \
    --notes "${RELEASE_NOTES}"


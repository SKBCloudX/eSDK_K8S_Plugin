#!/bin/bash
#
CUR_DIR=$(dirname $0)
OUTPUT_DIR="${CUR_DIR}/../output"

if [[ ! -d "${OUTPUT_DIR}" ]]; then
  echo "The output directory is not found: ${OUTPUT_DIR}"
  exit 1
fi
for tarfile in "${OUTPUT_DIR}"/*.tar; do
  [[ -e "${tarfile}" ]] || continue
  echo "docker load ${tarfile}..."
  docker load -i "${tarfile}"
  echo "Done!"
done


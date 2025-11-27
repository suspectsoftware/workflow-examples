#!/bin/bash

# Usage:
#   ./transform.sh --target-dir <directory> --version <value>
#
# Example:
#   ./transform.sh --target-dir ./myfiles --image-value 1.0.0-release.123
#

set -eu

# Default argument values
TARGET_DIR=""
VERSION=""

# Parse arguments
while [[ $# -gt 0 ]]; do
	case $1 in
		--target-dir)
			TARGET_DIR="$2"
			shift 2
			;;
		--version)
			VERSION="$2"
			shift 2
			;;
		*)
			echo "Unknown argument: $1"
			exit 1
			;;
	esac
done

if [[ -z "$TARGET_DIR" || -z "$VERSION" ]]; then
	echo "Usage: $0 --target-dir <dir> --version <value>"
	exit 1
fi

echo "-- Transforming files ----"
# Get a list of all .yml or .yaml files in the source directory
files=($(find "$TARGET_DIR" -type f \( -name "*.yml" -o -name "*.yaml" \)))

# If the file contains a spec.version field
# Update it with the provided value
for file in "${files[@]}"; do
    echo "-- Updating spec.version in $file ----"
    yq -e '.spec.version' "$file" >/dev/null 2>&1 && \
    yq -i '.spec.version = "'"${VERSION}"'"' "$file" || true
done

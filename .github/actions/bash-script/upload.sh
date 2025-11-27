#!/bin/bash

# Usage:
#   ./upload.sh --source-dir <directory> --target-dir <directory> --branch <branch-name>
#
# Example:
#   ./upload.sh --source-dir ./project --target-dir ./myfiles --branch main
#

set -eu

# Default argument values
WORKSPACE=""
SOURCE_DIRECTORY=""
TARGET_DIRECTORY=""

# Parse arguments
while [[ $# -gt 0 ]]; do
	case $1 in
		--branch)
			BRANCH_REF="$2"
			shift 2
			;;
		--source-dir)
			SOURCE_DIRECTORY="$2"
			shift 2
			;;
		--target-dir)
			TARGET_DIRECTORY="$2"
			shift 2
			;;
		*)
			echo "Unknown argument: $1"
			exit 1
			;;
	esac
done

if [[ -z "$BRANCH_REF" || -z "$SOURCE_DIRECTORY" || -z "$TARGET_DIRECTORY" ]]; then
	echo "Usage: $0 --source-dir <dir> --target-dir <dir> --branch <value>"
	exit 1
fi

mkdir -p ${TARGET_DIRECTORY}
cp -r ${SOURCE_DIRECTORY}/* ${TARGET_DIRECTORY}/

git config user.email "actions@github.com"
git config user.name "GitHub Actions"
git config pull.rebase true

# Define variables for retry
max_attempts=3
attempt=1
retry_delay=5 # in seconds

while [[ $attempt -le $max_attempts ]]; do
    git add -A $TARGET_DIRECTORY

    if git diff --quiet ${BRANCH_REF} ${TARGET_DIRECTORY}/; then
        echo "No changes detected in files"
        break
    else
        echo "Changes detected in files"
        git commit -m "Update files"
    fi

    if git pull && git push; then
        echo "Commit and push succesful to ${BRANCH_REF} branch"
        break
    else
        echo "Attempt $attempt failed, retrying in $retry_delay seconds..."
        sleep $retry_delay
        attempt=$((attempt + 1))
    fi
done

if [[ $attempt -gt $max_attempts ]]; then
    echo "Exceeded maximum attempts to push changes, giving up"
    exit 1
fi

#!/bin/bash
set -e

# Script-based bash action
# This script demonstrates a more complex bash action with a separate script file

echo "=== File Processor Action ==="

# Read inputs from environment variables
INPUT_PATH="${INPUT_PATH:-./}"
INPUT_PATTERN="${INPUT_PATTERN:-*.md}"
INPUT_OPERATION="${INPUT_OPERATION:-count}"

echo "Configuration:"
echo "  Path: $INPUT_PATH"
echo "  Pattern: $INPUT_PATTERN"
echo "  Operation: $INPUT_OPERATION"
echo ""

# Validate inputs
if [ ! -d "$INPUT_PATH" ] && [ ! -f "$INPUT_PATH" ]; then
    echo "Error: Path does not exist: $INPUT_PATH"
    exit 1
fi

# Perform operation
case "$INPUT_OPERATION" in
    count)
        echo "Counting files matching pattern..."
        COUNT=$(find "$INPUT_PATH" -name "$INPUT_PATTERN" -type f 2>/dev/null | wc -l)
        echo "Found $COUNT files"
        echo "count=$COUNT" >> $GITHUB_OUTPUT
        ;;
    
    list)
        echo "Listing files matching pattern..."
        FILES=$(find "$INPUT_PATH" -name "$INPUT_PATTERN" -type f 2>/dev/null)
        if [ -n "$FILES" ]; then
            echo "$FILES"
            # Save to multiline output
            {
                echo 'files<<EOF'
                echo "$FILES"
                echo 'EOF'
            } >> $GITHUB_OUTPUT
        else
            echo "No files found"
            echo "files=" >> $GITHUB_OUTPUT
        fi
        ;;
    
    size)
        echo "Calculating total size of files matching pattern..."
        TOTAL_SIZE=0
        while IFS= read -r file; do
            if [ -f "$file" ]; then
                SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
                TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
            fi
        done < <(find "$INPUT_PATH" -name "$INPUT_PATTERN" -type f 2>/dev/null)
        
        echo "Total size: $TOTAL_SIZE bytes"
        echo "total-size=$TOTAL_SIZE" >> $GITHUB_OUTPUT
        ;;
    
    *)
        echo "Error: Unknown operation: $INPUT_OPERATION"
        echo "Supported operations: count, list, size"
        exit 1
        ;;
esac

echo ""
echo "Operation completed successfully!"

# Create step summary
{
    echo "### File Processor Results"
    echo "- Operation: $INPUT_OPERATION"
    echo "- Pattern: $INPUT_PATTERN"
    echo "- Path: $INPUT_PATH"
} >> $GITHUB_STEP_SUMMARY

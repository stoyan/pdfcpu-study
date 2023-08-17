#!/bin/bash

# Check if an input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

while IFS= read -r file_path; do
    if [ -f "$file_path" ]; then
        # Calculate the MD5 hash of the file's content using md5
        file_hash=$(md5 -q "$file_path")
        echo "$file_hash,$file_path"
    else
        echo "File not found: $file_path"
    fi
done < "$input_file"


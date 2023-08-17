#!/bin/bash

# Check if an input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="dedup.txt"
prev_hash=""
first_line=true

while IFS= read -r line; do
    current_hash=$(echo "$line" | cut -d ',' -f 1)
    
    # If this is the first line or the hash is different from the previous line
    if $first_line || [ "$current_hash" != "$prev_hash" ]; then
        echo "$line" >> "$output_file"
        prev_hash="$current_hash"
    fi

    first_line=false
done < "$input_file"

echo "Duplicate lines removed. Result saved to $output_file"

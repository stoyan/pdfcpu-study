#!/bin/bash

# Check if input files are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <input_list> <output_dir> <stats_file>"
    exit 1
fi

input_list="$1"
output_dir="$2"
stats_file="$3"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

while IFS= read -r line; do
    hash=$(echo "$line" | cut -d ',' -f 1)
    file_path=$(echo "$line" | cut -d ',' -f 2)
    
    input_file="$file_path"
    tmp_output="$output_dir/tmp_${hash}.pdf"
    stats_line="$file_path"
    
    if [ -f "$input_file" ]; then
        # Run pdfcpu optimize
        ./pdfcpu optimize "$input_file" "$tmp_output"
        
        # Get file sizes before and after optimization
        size_before=$(stat -f %z "$input_file")
        size_after=$(stat -f %z "$tmp_output")
        
        # Append the stats to the stats file
        echo "${size_before},${size_after}" >> "$stats_file"
        
        echo "Processed: $file_path"
    else
        echo "File not found: $file_path"
    fi
    
done < "$input_list"

echo "Optimization stats written to $stats_file"

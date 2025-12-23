#!/bin/bash
# Example: Using temporary files in Bash

# Setup: Create temp file with automatic cleanup
temp_file=$(mktemp -t example.XXXXXX)
trap "rm -f $temp_file" EXIT

echo "✓ Created temp file: $temp_file"

# Write data to temp file
cat > "$temp_file" << 'EOF'
Sample data for processing
Line 1
Line 2
Line 3
EOF

echo "✓ Wrote data to temp file"

# Read and process the temp file
echo "✓ Processing file:"
while IFS= read -r line; do
    echo "  - $line"
done < "$temp_file"

# Example: Using temporary directory for multiple files
temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" EXIT

echo "✓ Created temp directory: $temp_dir"

# Create multiple files in temp directory
for i in {1..3}; do
    echo "File content $i" > "$temp_dir/file$i.txt"
done

echo "✓ Created 3 files in temp directory"
ls -la "$temp_dir"

# Example: Creating and executing a temporary script
temp_script=$(mktemp -t script.XXXXXX)
trap "rm -f $temp_script" EXIT
chmod +x "$temp_script"

cat > "$temp_script" << 'SCRIPT'
#!/bin/bash
echo "This is a temporary script running"
echo "Script arguments: $@"
exit 0
SCRIPT

echo "✓ Created and executing temp script"
"$temp_script" arg1 arg2

echo "✓ All operations completed"
echo "✓ Temporary files will be cleaned up automatically"

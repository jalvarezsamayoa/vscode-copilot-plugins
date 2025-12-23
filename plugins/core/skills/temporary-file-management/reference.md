# Temporary File Management - Reference Guide

Extended patterns, edge cases, and advanced cleanup strategies.

## Advanced Cleanup Patterns

### Pattern: Cleanup Registry (For Multiple Files)

When you create multiple temp files that need coordinated cleanup:

```bash
#!/bin/bash

# Create registry file to track all temp files
temp_registry=$(mktemp)
trap 'cat "$temp_registry" | xargs rm -f 2>/dev/null; rm -f "$temp_registry"' EXIT

create_temp_file() {
    local temp_file=$(mktemp)
    echo "$temp_file" >> "$temp_registry"
    echo "$temp_file"
}

# Usage
file1=$(create_temp_file)
file2=$(create_temp_file)
file3=$(create_temp_file)

# All three files cleaned up automatically
```

### Pattern: Explicit Resource Management

```python
import tempfile
import os
from contextlib import contextmanager

@contextmanager
def temp_files(*count):
    """Create N temporary files with guaranteed cleanup."""
    files = []
    try:
        for _ in range(count):
            f = tempfile.NamedTemporaryFile(delete=False)
            files.append(f)
        yield files
    finally:
        for f in files:
            try:
                os.unlink(f.name)
            except:
                pass

# Usage
with temp_files(3) as (file1, file2, file3):
    # Use all three files
    pass
# All cleaned up
```

### Pattern: Cleanup on Signal (Unix)

```bash
#!/bin/bash

temp_file=$(mktemp)

# Handle multiple exit conditions
cleanup() {
    rm -f "$temp_file"
    exit 130  # Standard SIGINT exit code
}

trap cleanup EXIT
trap cleanup INT TERM

# Long-running task
while true; do
    echo "processing..." >> "$temp_file"
    sleep 1
done
```

## Edge Cases & Solutions

### Edge Case: Large Files (Use Streaming)

❌ Don't buffer entire large files in temp storage:

```bash
# WRONG - loads entire file into memory
curl https://example.com/largefile.zip > "$temp_file"
process_file "$temp_file"
```

✅ Stream directly:

```bash
# RIGHT - processes while downloading
curl https://example.com/largefile.zip | gunzip | process_stdin
```

### Edge Case: Cleanup After Crash

If cleanup handler doesn't run (process killed):

```python
import tempfile
import atexit
import signal

class ManagedTemp:
    def __init__(self):
        self.files = []

    def create(self):
        f = tempfile.NamedTemporaryFile(delete=False)
        self.files.append(f.name)
        return f

    def cleanup_all(self):
        for f in self.files:
            try:
                os.remove(f)
            except:
                pass

# Register cleanup
managed = ManagedTemp()
atexit.register(managed.cleanup_all)
for sig in [signal.SIGTERM, signal.SIGINT, signal.SIGKILL]:
    signal.signal(sig, lambda: managed.cleanup_all())
```

### Edge Case: Permission Issues

```bash
# If can't write to /tmp, try alternatives
temp_file=$(mktemp "${TMPDIR:-/tmp}/myapp.XXXXXX" 2>/dev/null) || \
temp_file=$(mktemp "$HOME/.tmp/myapp.XXXXXX" 2>/dev/null) || \
temp_file=$(mktemp "./tmp/myapp.XXXXXX")

trap "rm -f $temp_file" EXIT
```

### Edge Case: Temp Directory Full

```bash
# Check available space before creating large files
if [[ $(df /tmp | tail -1 | awk '{print $4}') -lt 1048576 ]]; then
    # Less than 1GB available
    echo "Warning: /tmp may be full"
fi

temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT
```

## Cross-Platform File Path Handling

### Bash (Platform-Aware)

```bash
#!/bin/bash

# Detect OS
case "$(uname -s)" in
    Darwin)
        # macOS
        temp_file=$(mktemp -t myapp.XXXXXX)
        ;;
    Linux)
        # Linux
        temp_file=$(mktemp /tmp/myapp.XXXXXX)
        ;;
    MINGW* | MSYS* | CYGWIN*)
        # Windows (Git Bash/WSL)
        temp_file=$(mktemp -t myapp.XXXXXX)
        ;;
    *)
        temp_file=$(mktemp)
        ;;
esac

trap "rm -f $temp_file" EXIT
```

### Python (Auto-Detected)

```python
import tempfile
import platform

# Python automatically uses correct temp dir per platform
# Windows: %APPDATA%\Local\Temp or %TEMP%
# Unix: /tmp, /var/tmp, or TMPDIR env var

temp_file = tempfile.NamedTemporaryFile(delete=False)
# Works correctly on all platforms automatically
```

### Node.js (Auto-Detected)

```javascript
const os = require('os');
const path = require('path');

// os.tmpdir() returns correct directory for platform
const tempDir = os.tmpdir();
// Windows: C:\Users\username\AppData\Local\Temp
// Unix: /tmp
```

## Cleanup Reliability Guarantees

### Strong Guarantee (Bash)

```bash
set -e  # Exit on error
set -o pipefail  # Exit on pipe failure

temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT  # ALWAYS runs, even on error

# Even if this fails, cleanup runs
false_command || true
```

### Medium Guarantee (Python with Try-Finally)

```python
temp_file = None
try:
    temp_file = tempfile.NamedTemporaryFile(delete=False).name
    # Do work
except Exception:
    raise
finally:
    if temp_file and os.path.exists(temp_file):
        os.remove(temp_file)
```

### Best Guarantee (Context Manager)

```python
import tempfile

with tempfile.NamedTemporaryFile() as f:
    # Guaranteed cleanup on any exit
    pass  # Auto-deleted
```

## Temporary Scripts

### Creating & Running Executable Scripts

```bash
# Create temp script with proper permissions
temp_script=$(mktemp -t script.XXXXXX)
chmod +x "$temp_script"
trap "rm -f $temp_script" EXIT

cat > "$temp_script" << 'EOF'
#!/bin/bash
echo "Running in temp script"
exit 0
EOF

# Execute script
"$temp_script"
```

### Python Temporary Script

```python
import tempfile
import subprocess
import os

temp_script = tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False)
temp_script.write('''
import sys
print("Running temporary script")
sys.exit(0)
''')
temp_script.close()

try:
    subprocess.run(['python3', temp_script.name], check=True)
finally:
    os.remove(temp_script.name)
```

## Monitoring Temp File Usage

### List All Temp Files (Debug)

```bash
# See all temp files created by current shell
temp_dir="${TMPDIR:-/tmp}"
ls -lah "$temp_dir" | grep "$(date +%Y%m%d)"

# Count temp files
find "$temp_dir" -type f -mtime -1 | wc -l
```

### Temp Disk Usage

```bash
# Check how much space temp files use
du -sh "${TMPDIR:-/tmp}"
```

## Common Mistakes to Avoid

### ❌ Mistake 1: Hardcoded Paths

```bash
# Wrong - predictable, insecure, may not work
echo "data" > /tmp/myfile
```

### ✅ Solution

```bash
# Correct - random, secure
temp_file=$(mktemp)
echo "data" > "$temp_file"
```

### ❌ Mistake 2: No Cleanup on Error

```bash
# Wrong - temp file orphaned on error
temp_file=$(mktemp)
do_task "$temp_file"
rm "$temp_file"  # Never runs if do_task fails
```

### ✅ Solution: Use Trap Handlers

```bash
# Correct - cleanup guaranteed
temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT
do_task "$temp_file"
```

### ❌ Mistake 3: Forgetting Quotes

```bash
# Wrong - breaks with spaces in filenames
for file in $(ls $temp_dir); do rm $file; done
```

### ✅ Solution: Always Quote Variables

```bash
# Correct - handles all filenames
for file in "$temp_dir"/*; do rm "$file"; done
```

### ❌ Mistake 4: Not Handling Cleanup Failure

```bash
# Wrong - command fails if file locked
temp_file=$(mktemp)
trap "rm $temp_file" EXIT
do_task "$temp_file"  # If file stays locked, cleanup will fail
```

### ✅ Solution: Handle Cleanup Gracefully

```bash
# Correct - cleanup failure doesn't crash
temp_file=$(mktemp)
trap 'rm -f $temp_file 2>/dev/null' EXIT
do_task "$temp_file"
```

## Performance Considerations

### Use RAM Disk for Speed (macOS)

```bash
# Create 1GB RAM disk
diskutil erasevolume HFS+ RAM_DISK $(hdiutil attach -nomount ram://2097152)

# Temp files on RAM disk are much faster
temp_file=/Volumes/RAM_DISK/temp_file
```

### Use Memory-Mapped Files

```python
import tempfile
import mmap

# For large files, use mmap for efficiency
with tempfile.NamedTemporaryFile() as f:
    f.write(b'x' * 1000000)
    f.flush()

    with mmap.mmap(f.fileno(), 0) as m:
        # Work with memory-mapped file
        pass
```

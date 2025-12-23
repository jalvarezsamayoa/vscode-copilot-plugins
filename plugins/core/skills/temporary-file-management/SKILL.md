---
name: temporary-file-management
description: Agents should use this skill when they need to create temporary files or scripts to perform a task. Teaches best practices for safe creation, cleanup, and platform-specific handling.
---

# Temporary File Management for Agents

When you need to create temporary files or scripts during task execution, use this
skill to ensure safety, cleanup, and platform compatibility.

**CRITICAL INSTRUCTION**: Agents must NEVER pollute the current repository with temporary files. If you need to create temporary files to test behavior or store information for future use, you MUST ONLY use the `tmp/` directory at the root of the repository. System temp directories (`/tmp`, `$TMPDIR`, `%TEMP%`) must not be used for repository-related work.

## Quick Reference

**For Repository-Related Work:**

1. Use `tmp/` directory at repository root (NOT system temp)
2. Generate unique filename (use timestamp + random)
3. Create file in `tmp/` directory
4. Perform your task
5. Clean up on success AND on error

**For Non-Repository Work:**

1. Generate unique filename (use timestamp + random)
2. Create file in safe directory (`$TMPDIR` or system default)
3. Perform your task
4. Clean up on success AND on error
5. Handle platform differences (macOS, Linux, Windows)

## Repository-Specific Temporary Files

When working within a repository context, you MUST use the `tmp/` directory at the repository root:

### Bash (Repository Work)

```bash
# Create temp file in repository tmp/ directory
temp_file="tmp/task-$(date +%s)-$RANDOM.txt"

# Always trap for cleanup
trap "rm -f $temp_file" EXIT

# Use the file
echo "content" > "$temp_file"
your_command "$temp_file"
# Cleanup happens automatically on exit
```

### Python (Repository Work)

```python
import os
import tempfile

# Use repository tmp/ directory
repo_tmp = "tmp"
os.makedirs(repo_tmp, exist_ok=True)

temp_file = os.path.join(repo_tmp, f"task-{int(time.time())}-{random.randint(1000, 9999)}.txt")

try:
    with open(temp_file, 'w') as f:
        f.write("content")
    # Do work with temp_file
finally:
    if os.path.exists(temp_file):
        os.remove(temp_file)
```

### Node.js (Repository Work)

```javascript
const fs = require('fs');
const path = require('path');

// Use repository tmp/ directory
const tmpDir = 'tmp';
if (!fs.existsSync(tmpDir)) {
  fs.mkdirSync(tmpDir, { recursive: true });
}

const timestamp = Date.now();
const random = Math.random().toString(36).substring(7);
const tempFile = path.join(tmpDir, `temp-${timestamp}-${random}.txt`);

// Always register cleanup
function cleanup() {
  if (fs.existsSync(tempFile)) {
    fs.unlinkSync(tempFile);
  }
}
process.on('exit', cleanup);
process.on('SIGINT', () => { cleanup(); process.exit(); });

// Use the file
fs.writeFileSync(tempFile, 'content');
// Do work with tempFile
cleanup();
```

## Safe Temporary File Creation

When creating temporary files outside of repository context, always ensure they have unique names and will be
cleaned up properly.

### Bash

```bash
# Create unique temp file (works on all platforms)
temp_file=$(mktemp)           # Creates in system temp
temp_file=$(mktemp /tmp/XXXXXX)  # Explicit location

# Or with custom prefix
temp_file=$(mktemp -t myapp.XXXXXX)

# Always trap for cleanup
trap "rm -f $temp_file" EXIT

# Use the file
echo "content" > "$temp_file"
your_command "$temp_file"
# Cleanup happens automatically on exit
```

### Python

```python
import tempfile
import os
import atexit

# Automatic cleanup on exit
temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.txt')
temp_path = temp_file.name
temp_file.close()

# Register cleanup
def cleanup():
    if os.path.exists(temp_path):
        os.remove(temp_path)
atexit.register(cleanup)

# Use the file
with open(temp_path, 'w') as f:
    f.write("content")

# Or use context manager (auto-deletes)
with tempfile.NamedTemporaryFile(mode='w', delete=True, suffix='.txt') as f:
    f.write("content")
    # File auto-deleted when exiting block
```

### JavaScript/Node.js

```javascript
const fs = require('fs');
const path = require('path');
const os = require('os');

// Create unique temp file
const tempDir = os.tmpdir();
const timestamp = Date.now();
const random = Math.random().toString(36).substring(7);
const tempFile = path.join(tempDir, `temp-${timestamp}-${random}.txt`);

// Always register cleanup
function cleanup() {
  if (fs.existsSync(tempFile)) {
    fs.unlinkSync(tempFile);
  }
}
process.on('exit', cleanup);
process.on('SIGINT', () => { cleanup(); process.exit(); });

// Use the file
fs.writeFileSync(tempFile, 'content');
// Do work with tempFile
cleanup();
```

### Go

```go
package main

import (
    "os"
    "io/ioutil"
    "path/filepath"
)

// Create temp file with cleanup
tempFile, err := ioutil.TempFile("", "myapp-*.txt")
if err != nil {
    // handle error
}
defer os.Remove(tempFile.Name())

// Use the file
tempFile.WriteString("content")
tempFile.Close()
// File cleaned up when function exits
```

### Ruby

```ruby
require 'tempfile'
require 'fileutils'

# Auto-cleanup with Tempfile class
temp_file = Tempfile.new('myapp')
begin
  puts "Created: #{temp_file.path}"
  temp_file.write("content")
  temp_file.flush

  # Use the file
  temp_file.rewind
  content = temp_file.read
ensure
  temp_file.close
  temp_file.unlink  # Delete the file
end

# Or use block syntax (auto-cleanup)
Tempfile.open('myapp') do |f|
  f.write("content")
  f.flush
  # Auto-deleted when block exits
end
```

## Safe Temporary Directory Creation

When you need a temporary directory for multiple files:

### Bash for Directories

```bash
temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" EXIT

# Use directory
cp file1 "$temp_dir/"
cp file2 "$temp_dir/"
# Directory cleaned up on exit
```

### Python for Directories

```python
import tempfile
import shutil

# Auto-cleanup on context exit
with tempfile.TemporaryDirectory() as temp_dir:
    # Use temp_dir for multiple files
    file_path = os.path.join(temp_dir, 'file.txt')
    with open(file_path, 'w') as f:
        f.write("content")
    # Directory auto-deleted on exit
```

### Node.js for Directories

```javascript
const { mkdtempSync, rmSync } = require('fs');
const { tmpdir } = require('os');
const { join } = require('path');

const tempDir = mkdtempSync(join(tmpdir(), 'myapp-'));

// Register cleanup
function cleanup() {
  if (fs.existsSync(tempDir)) {
    fs.rmSync(tempDir, { recursive: true });
  }
}
process.on('exit', cleanup);

// Use directory
// Cleanup on exit
```

### Ruby for Directories

```ruby
require 'tmpdir'
require 'fileutils'

# Create temp directory with auto-cleanup
temp_dir = Dir.mktmpdir('myapp')
begin
  puts "Created: #{temp_dir}"

  # Create multiple files
  File.write(File.join(temp_dir, 'file1.txt'), 'content1')
  File.write(File.join(temp_dir, 'file2.txt'), 'content2')

  # Use files
  Dir.each_child(temp_dir) { |f| puts f }
ensure
  FileUtils.remove_entry(temp_dir)  # Cleanup
end
```

## Platform-Specific Considerations

### Linux/macOS

- `$TMPDIR` or `/tmp` usually available
- `mktemp` always available
- Permissions: Others can read temp files in `/tmp` by default
- Use `mktemp -t` for restrictive permissions

### Windows

- Use `%TEMP%` or `%TMP%` environment variables
- Node.js `os.tmpdir()` handles this automatically
- Python `tempfile` module handles this automatically
- Bash with WSL respects system temp directory
- Be careful with backslashes in paths

## Unique Filename Strategies

### Strategy 1: Timestamp + Random (Most Common)

```bash
temp_file="/tmp/task-$(date +%s)-$RANDOM.txt"
```

### Strategy 2: UUID (Most Unique)

```bash
temp_file="/tmp/task-$(uuidgen).txt"  # macOS
temp_file="/tmp/task-$(cat /proc/sys/kernel/random/uuid).txt"  # Linux
```

### Strategy 3: Process ID

```bash
temp_file="/tmp/task-$$.txt"  # $$ = current process ID
```

**Recommendation**: Use language standard libraries (`mktemp`, `tempfile`, etc.)
which are safer than manual approaches.

## Cleanup Patterns

### Pattern 1: Trap Handler (Bash)

```bash
temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT
# Automatic cleanup on any exit
```

### Pattern 2: Try-Finally (Python)

```python
temp_file = tempfile.NamedTemporaryFile(delete=False)
try:
    # Do work
finally:
    os.remove(temp_file.name)  # Always cleanup
```

### Pattern 3: Try-Catch-Finally (JavaScript)

```javascript
const tempFile = createTempFile();
try {
    // Do work with tempFile
} catch (e) {
    throw e;  // Re-throw after cleanup
} finally {
    cleanup(tempFile);  // Always cleanup
}
```

## When NOT to Use Temporary Files

❌ **Don't use temp files for:**

- Storing sensitive data (passwords, tokens, API keys)
- Persisting data beyond the current execution
- Large files (> 100MB) - use streaming instead
- Configuration files (use project-local files instead)
- Output users need to access (write to defined output path)
- **NEVER use system temp directories for repository-related work** - Always use `tmp/` at repository root

✅ **Good use cases:**

- Scripts generated for execution
- Test data during processing
- Intermediate build artifacts
- Cache files for a single operation
- Downloaded content for processing

## Permissions and Security

### Restrictive Permissions (Linux/macOS)

```bash
# Create file with restrictive permissions (0600 = user read/write only)
temp_file=$(mktemp -t myapp.XXXXXX)
chmod 600 "$temp_file"
```

### Never do this

- Use predictable paths (`/tmp/myfile` without randomness)
- Store passwords or tokens in temp files
- Leave temp files world-readable in shared systems
- Store unencrypted sensitive data

## Handling Cleanup Failures

### Graceful Degradation

```bash
# Don't fail if cleanup fails
temp_file=$(mktemp)
trap 'rm -f $temp_file 2>/dev/null' EXIT

# Do work
do_task "$temp_file"

# Cleanup happens, but won't crash if it fails
```

### Logging Cleanup Issues

```python
import logging

temp_file = tempfile.NamedTemporaryFile(delete=False)
try:
    # Do work
finally:
    try:
        os.remove(temp_file.name)
    except Exception as e:
        logging.warning(f"Failed to cleanup {temp_file.name}: {e}")
```

## Referencing Supporting Materials

See the following for detailed patterns and utilities:

- `reference.md` - Extended cleanup patterns and edge cases
- `scripts/` directory - Reusable shell utilities
- `examples/` directory - Real-world usage by language

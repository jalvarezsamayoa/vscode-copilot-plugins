#!/usr/bin/env python3
"""Example: Using temporary files in Python"""

import tempfile
import os
import sys

# Example 1: Using context manager (best practice - auto-cleanup)
print("✓ Example 1: Temporary file with context manager")
with tempfile.NamedTemporaryFile(mode='w', delete=True, suffix='.txt') as f:
    temp_file = f.name
    f.write("Sample data\nLine 1\nLine 2\n")
    f.flush()

    print(f"  Created: {temp_file}")
    with open(temp_file, 'r') as read_f:
        print(f"  Content: {read_f.read()}")
print("  Auto-cleaned up on exit\n")

# Example 2: Manual cleanup with try-finally
print("✓ Example 2: Manual cleanup with try-finally")
temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.txt').name

try:
    print(f"  Created: {temp_file}")
    with open(temp_file, 'w') as f:
        f.write("Manual cleanup example\n")

    with open(temp_file, 'r') as f:
        print(f"  Content: {f.read()}")
finally:
    if os.path.exists(temp_file):
        os.remove(temp_file)
        print("  Manually cleaned up\n")

# Example 3: Temporary directory with multiple files
print("✓ Example 3: Temporary directory")
with tempfile.TemporaryDirectory() as temp_dir:
    print(f"  Created: {temp_dir}")

    # Create multiple files
    for i in range(3):
        file_path = os.path.join(temp_dir, f'file{i}.txt')
        with open(file_path, 'w') as f:
            f.write(f'File {i} content\n')

    # List files
    files = os.listdir(temp_dir)
    print(f"  Files created: {files}")
print("  Directory auto-cleaned up\n")

# Example 4: Creating temporary scripts
print("✓ Example 4: Temporary script")
with tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False) as f:
    temp_script = f.name
    f.write('''#!/usr/bin/env python3
import sys
print(f"Temporary script running with args: {sys.argv[1:]}")
sys.exit(0)
''')

try:
    os.chmod(temp_script, 0o755)
    import subprocess
    result = subprocess.run([sys.executable, temp_script, 'arg1', 'arg2'],
                          capture_output=True, text=True)
    print(f"  {result.stdout.strip()}\n")
finally:
    if os.path.exists(temp_script):
        os.remove(temp_script)

# Example 5: Using NamedTemporaryFile with delete=False
print("✓ Example 5: NamedTemporaryFile with manual deletion")
temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.txt')
temp_path = temp_file.name
temp_file.write(b'Binary data example\n')
temp_file.close()

print(f"  File persists: {os.path.exists(temp_path)}")

# Manual cleanup
os.remove(temp_path)
print(f"  After removal: {os.path.exists(temp_path)}\n")

print("✓ All examples completed")

# Core Plugin

Core skills that help AI agents properly operate in repositories.

## Overview

The `core` plugin provides foundational knowledge that enables agents to write
safe, reliable, and platform-independent code. It focuses on patterns and best
practices that agents should follow when performing automated tasks.

## Skills

### Temporary File Management

Teaches agents how to safely create, use, and clean up temporary files and scripts
during task execution.

**When to use:** Any time an agent needs to create temporary files, scripts, or
directories for intermediate processing.

**Key topics:**

- Safe file creation with unique names
- Guaranteed cleanup patterns (trap handlers, context managers, try-finally)
- Platform differences (macOS, Linux, Windows)
- Security considerations and permissions
- Cleanup failure handling
- When NOT to use temporary files

**Supported languages:**

- Bash/Shell
- Python
- JavaScript/Node.js
- Go
- Ruby

## Installation

### Option 1: Local Testing (Recommended for Development)

Test the plugin locally before installing it into your projects:

```bash
# Navigate to the repository root
cd /path/to/claude-code-plugins

# Run Claude Code with the plugin loaded
cc --plugin-dir ./plugins/core
```

This allows you to test all skills immediately without copying files. Perfect for development and quick verification.

### Option 2: Copy to Your Project

For persistent use in a specific project:

```bash
# Copy the plugin to your project's .claude-plugin directory
mkdir -p my-project/.claude-plugin
cp -r plugins/core my-project/.claude-plugin/core

# Navigate and use in your project
cd my-project
cc
```

### Option 3: Install from Marketplace

To use this repository as a marketplace plugin source:

#### Add to Your Claude Code Configuration

Edit your `.claude/settings.json`:

```json
{
  "plugins": {
    "marketplaces": [
      {
        "name": "claude-code-plugins",
        "source": "https://github.com/anthropics/claude-code-plugins",
        "type": "github"
      }
    ]
  }
}
```

Or manually register the marketplace with a local path:

```json
{
  "plugins": {
    "marketplaces": [
      {
        "name": "local-plugins",
        "source": "/path/to/claude-code-plugins",
        "type": "local"
      }
    ]
  }
}
```

#### Install the Plugin

Once the marketplace is registered:

```bash
# Install from the marketplace
cc /plugin install core@claude-code-plugins

# Or with a local marketplace
cc /plugin install core@local-plugins
```

## Usage

### For AI Agents

The temporary file management skill is designed to be always-loaded in agent
context. When an agent needs to create temporary files, it will automatically
have access to:

- Quick reference patterns for each language
- Safe creation and cleanup strategies
- Platform-specific guidance
- Common mistakes and solutions
- Performance considerations

### Example Agent Query

> "I need to create a temporary script to process some data. What's the best way
> to do this in Bash?"

The agent will reference this skill and provide safe, reliable code patterns.

## Testing

### Local Testing Workflow

After installing with `--plugin-dir`, verify the skill is working:

1. **Start a Claude Code session:**

   ```bash
   cc --plugin-dir ./plugins/core
   ```

2. **Test the skill with natural language queries:**
   - "How do I safely create a temporary file in Bash?"
   - "What are the best practices for temporary file cleanup?"
   - "Show me a temporary file example in Python"
   - "How do I handle cleanup in Go?"

3. **Verify skill behavior:**
   - Claude should reference the temporary file management skill
   - Examples should match the language you asked about
   - Platform-specific guidance should appear when relevant

### Troubleshooting

If the skill doesn't appear to trigger:

- Verify the plugin is loaded: `cc --version` should show plugin information
- Check that your question matches skill keywords (temporary file, cleanup, etc.)
- Review the SKILL.md file to understand when the skill activates
- Restart Claude Code after plugin changes

### Testing Before Marketplace Distribution

Before submitting to a marketplace or distributing your plugin:

1. Test with local `--plugin-dir` method
2. Test with copied method in a separate project
3. Verify all example code runs without errors
4. Check skill descriptions trigger appropriately
5. Review documentation for clarity and completeness

## Plugin Contents

```text
core/
├── .claude-plugin/
│   └── plugin.json                           # Plugin manifest
├── skills/
│   └── temporary-file-management/
│       ├── SKILL.md                          # Main skill content
│       ├── reference.md                      # Extended patterns
│       ├── scripts/
│       │   └── create-temp.sh               # Reusable utilities
│       └── examples/
│           ├── bash-example.sh              # Bash examples
│           ├── python-example.py            # Python examples
│           ├── nodejs-example.js            # Node.js examples
│           └── go-example.go                # Go examples
└── README.md                                  # This file
```

## Key Features

✅ **Language-Agnostic Patterns** - Core principles apply across all languages
✅ **Platform-Aware** - Specific guidance for macOS, Linux, and Windows
✅ **Practical Focus** - Real-world patterns and common mistakes
✅ **Comprehensive Examples** - Working code in all major languages
✅ **Always-Available Context** - No special invocation needed
✅ **Security First** - Emphasis on safe creation and cleanup

## Example Code

### Bash

```bash
temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT
echo "data" > "$temp_file"
# Your work here
# Cleanup happens automatically
```

### Python

```python
import tempfile

with tempfile.NamedTemporaryFile() as f:
    f.write(b"data")
    # Your work here
# Auto-cleanup on context exit
```

### Node.js

```javascript
const fs = require('fs');
const os = require('os');
const path = require('path');
const tempFile = path.join(os.tmpdir(), `temp-${Date.now()}.txt`);

fs.writeFileSync(tempFile, 'data');
try {
    // Your work here
} finally {
    fs.unlinkSync(tempFile);
}
```

## Skill Structure

The `temporary-file-management` skill is organized for quick reference:

1. **SKILL.md** (1,500-2,000 words)
   - Quick reference patterns
   - Safe creation for each language
   - Platform considerations
   - Cleanup patterns
   - Common mistakes
   - When NOT to use temp files

2. **reference.md** (Extended)
   - Advanced cleanup patterns
   - Edge cases and solutions
   - Performance optimization
   - Monitoring and debugging

3. **examples/** - Working code samples
   - Bash example with error handling
   - Python with context managers
   - Node.js with async cleanup
   - Go with defer-based cleanup

4. **scripts/** - Reusable utilities
   - Shell function libraries
   - Cross-platform helpers

## Configuration

No configuration required. The plugin is designed to work out-of-the-box.

## Future Extensions

This plugin is designed to grow with additional core skills:

- Repository navigation patterns
- Output formatting and reporting
- Error handling and logging
- File system operations
- Git operations best practices
- Process management

Each skill will follow the same practical, language-agnostic approach.

## Contributing

To contribute additional core skills:

1. Create a new skill directory under `skills/`
2. Include SKILL.md with quick reference
3. Add reference.md for extended patterns
4. Provide examples in common languages
5. Include reusable scripts/utilities
6. Update this README

## Support

For questions or issues:

- Check the skill documentation in SKILL.md
- Review examples in the `examples/` directory
- See `reference.md` for advanced patterns
- Refer to official language documentation

## License

MIT - See repository LICENSE file

---

**Last Updated**: 2025-12-22
**Version**: 0.1.0

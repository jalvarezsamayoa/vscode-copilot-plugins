---
name: prompting:command-builder
description: Interactive command builder that creates high-quality custom Claude slash commands. Guides users through command specification, applies best practices, validates quality, and saves to specified directory (defaults to .claude/commands/).
---

# Command Builder

Create professional-quality custom Claude slash commands using best practices.

This command guides you through an interactive workflow to design and generate
custom commands that follow prompt engineering best practices.

## Usage

```bash
/prompting:command-builder [path]
```

**Arguments:**

- `[path]` (optional) - Directory to save the command file. Defaults to `.claude/commands/` if not provided.

**Examples:**

- `/prompting:command-builder` - Creates command in `.claude/commands/` (default behavior)
- `/prompting:command-builder plugins/prompting/commands` - Creates command in `plugins/prompting/commands/`
- `/prompting:command-builder .claude/custom-commands` - Creates command in a custom directory

Then follow the interactive prompts to specify your command.

## Workflow Overview

1. **Specify Command** - Provide command name and purpose
2. **Refine with Agent** - Let prompting agent enhance using best practices
3. **Review Suggestions** - Approve improvements suggested by agent
4. **Preview** - Review generated command file
5. **Confirm Save** - Ask permission if file exists, then save
6. **Confirmation** - Show success and usage instructions

## Interactive Workflow

### Step 1: Command Specification

You'll be asked for:

**Command Name** (kebab-case)

```text
Examples: analyze-code, summarize-text, format-json
Format: lowercase letters, hyphens (no spaces or underscores)
```

**Command Purpose** (clear, specific description)

```text
Example: "Analyzes source code for quality issues and suggests improvements"

What it should be:
- Specific about what the command does
- Who would use it (optionally)
- What output to expect (optionally)

Examples:
✅ "Summarizes long documents into concise bullet-point summaries"
✅ "Converts English text into any language while preserving formatting"
✅ "Reviews code for security vulnerabilities and provides fixes"
❌ "Helps with stuff" (too vague)
❌ "Does something useful" (not specific enough)
```

### Step 2: Agent Refinement

The prompting agent will:

1. **Analyze** your command purpose against best practices
2. **Identify gaps** (missing format specs, examples, constraints)
3. **Suggest improvements** with explanations
4. **Present options** for your approval

Example improvements suggested:

```markdown
✅ Add explicit output format: "Return JSON with structure..."
✅ Add example usage: "Example: /your-command analyze app.js"
✅ Add role context: "You are a senior code reviewer"
```

### Step 3: Review & Approve

For each suggestion, you can:

- **Approve** - Accept the improvement
- **Modify** - Request specific changes to the suggestion
- **Reject** - Skip this improvement
- **View Context** - See the full improvement with explanation

The agent will ask:

```markdown
Would you like me to:
1. Apply all suggestions ✓
2. Modify specific suggestions
3. Reject certain improvements
4. View more detail on a suggestion
```

### Step 4: Preview Command

Before saving, review the complete command file:

```markdown
Command Name: analyze-code
Description: Analyzes source code for quality issues...

Full Command Content:
---
[Complete markdown command file]
---

Ready to save?
```

### Step 5: Save Confirmation

**If file doesn't exist:**

```markdown
✅ Ready to save to: .claude/commands/analyze-code.md
Save? (yes/no)
```

**If file exists:**

```markdown
⚠️  File already exists: .claude/commands/analyze-code.md
Replace? (yes/no)
Backup will be created: .claude/commands/analyze-code.md.backup
```

### Step 6: Success & Usage

On successful save:

```markdown
✅ Command created: .claude/commands/analyze-code.md

Your new command is ready to use!

Usage:
  /analyze-code [arguments]

To test your command:
  1. Start a new Claude Code session
  2. Type: /analyze-code
  3. Your command will appear in the command list

To edit later:
  • Edit the file directly: .claude/commands/analyze-code.md
  • Or run command-builder again and replace the file

Examples of what your command does:
  [Examples from the generated command file]
```

## Path Argument Handling

When you provide a path argument, the workflow adapts:

1. **Parse Path** - The builder extracts the directory path from `$ARGUMENTS`
2. **Validate Path** - Creates the directory if it doesn't exist
3. **Save Location** - Saves the command to `{path}/{command-name}.md`
4. **Default Behavior** - If no path is provided, uses `.claude/commands/`

**Examples:**

- `/prompting:command-builder` → Saves to `.claude/commands/my-command.md`
- `/prompting:command-builder plugins/prompting/commands` → Saves to `plugins/prompting/commands/my-command.md`
- `/prompting:command-builder .claude/local-commands` → Saves to `.claude/local-commands/my-command.md`

The directory structure will be created automatically if needed.

## Command Generation Details

The builder creates commands with this structure:

### Frontmatter (YAML)

```yaml
---
name: command-name # Your command identifier (kebab-case)
description: Brief overview # What the command does
version: 0.1.0 # Semantic version (auto-generated)
allowed-tools: Read, Write # Tools this command can use (auto-inferred)
tags: [tag1, tag2] # Category tags (auto-generated)
---
```

### Sections

```markdown
## Overview

[Clear, detailed explanation of what the command does]

## Usage

[How to invoke the command and what arguments it takes]

## Examples

[Real-world usage examples]
[Show input and expected output]

## Output Format

[Explicit specification of how output is formatted]
[Include example output]

## Notes

[Any special considerations or limitations]
```

## Best Practices Applied

Every generated command includes:

✅ **Clear Description** - Specific, unambiguous purpose
✅ **Explicit Output Format** - Exactly how the response is structured
✅ **Usage Examples** - Real-world scenarios and invocation examples
✅ **Role Definition** - The AI's role when executing the command
✅ **Output Format Specification** - Formats like JSON, markdown, etc.
✅ **Constraints** - Limits on length, scope, or content
✅ **Section Headers** - Organized, scannable structure

## Examples

### Example 1: Simple Command

User provides:

- Name: `summarize`
- Purpose: `Summarizes text into bullet points`

Generated command includes:

- Clear role: "You are an expert summarizer"
- Output format: "Markdown bullet list, 3-5 items"
- Examples: Before/after summary samples
- Constraints: "Keep each point under 25 words"

### Example 2: Complex Command

User provides:

- Name: `code-reviewer`
- Purpose: `Reviews code and suggests improvements`

Generated command includes:

- Role: "You are a senior code reviewer with 15+ years experience"
- Input format: "Paste code to review"
- Output format: "JSON with issues array, each containing severity, line, suggestion"
- Examples: Code before, review output shown
- Constraints: "Focus on: security, performance, readability"
- Tools: "Read, Write, Bash (for test execution)"

## Tips for Best Results

### Be Specific About Purpose

```markdown
❌ "Helps with code"
✅ "Identifies unused variables and suggests removal strategies"
```

### Think About Output Format

The builder will ask: What format do you want?

- Markdown with sections?
- JSON structure?
- Simple text list?
- Code with comments?

### Include Context

The agent will suggest role and context:

- "You are a..." (expert, reviewer, teacher, translator)
- Audience level (beginner, intermediate, expert)
- Any special constraints or requirements

### Plan for Examples

Good commands include examples:

- What the command does best
- Common use cases
- Example input and output

## Troubleshooting

### Command file already exists

- You'll be asked if you want to replace it
- A backup is automatically created

### Command name has spaces

- Builder will correct to kebab-case automatically
- Example: "My Command" → "my-command"

### Purpose seems too vague

- Agent will suggest clarifications
- You can refine during the approval step

### Want to edit after creation

- Edit the command file directly (at whatever path you specified)
- Or run command-builder again with the same path

### Where do I save plugin commands?

- For plugin commands: use `/prompting:command-builder plugins/your-plugin/commands`
- For project commands: use `/prompting:command-builder` (defaults to `.claude/commands/`)
- For custom locations: specify the full path relative to your project root

## Next Steps

After creating a command:

1. **Test your command** - Invoke it and verify it works as expected
2. **Refine as needed** - Edit the command file if improvements needed
3. **Create more commands** - Build a library of custom commands
4. **Share with team** - Commit to version control and share

## See Also

- **Prompt Best Practices Skill** - Learn the principles behind quality commands
- **Your Generated Commands** - `.claude/commands/` directory
- **Claude Code Documentation** - <https://docs.claude.com>

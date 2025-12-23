# Prompting Plugin

Comprehensive prompt engineering support for Claude Code. Master the art of
writing effective prompts with built-in best practices guidance, autonomous
quality enforcement, and automated command generation.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Components](#components)
- [Usage Examples](#usage-examples)
- [Workflow](#workflow)
- [Best Practices](#best-practices)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

The `prompting` plugin helps users and AI agents master prompt engineering by:

- **Teaching best practices** - Comprehensive skill covering 8 core principles
- **Enforcing quality** - Autonomous agent validates and improves commands
- **Automating generation** - Interactive command builder creates professional
  commands

Whether you're writing prompts for AI assistants, creating custom Claude commands,
or training team members, this plugin provides the tools and knowledge you need.

## Features

✅ **Prompt Best Practices Skill** - Comprehensive guide to prompt engineering
✅ **Prompting Agent** - Enforces and follows best practices (Opus model)
✅ **Command Builder** - Create custom commands automatically
✅ **Quality Standards** - Validates commands meet best practices
✅ **Interactive Workflow** - User control over generated commands
✅ **8 Core Principles** - Clarity, context, format, examples, constraints,
iteration, efficiency, and templates
✅ **Real-World Examples** - Good vs bad prompt comparisons
✅ **Automated Refinement** - Suggestions with user approval

## Installation

### Quick Start

```bash
cc --plugin-dir plugins/prompting
```

### Copy to Project

```bash
mkdir -p .claude-plugin
cp -r plugins/prompting .claude-plugin/prompting
```

### From Marketplace

```bash
cc /plugin install prompting
```

### Requirements

- Claude Code CLI (latest version)
- Claude Opus access (for prompting agent)
- 50KB disk space for plugin files

## Components

### 1. Skill: Prompt Best Practices

**File**: `skills/prompt-best-practices/SKILL.md`

Comprehensive guide to writing effective prompts covering:

#### Core Principles

1. **Clarity and Specificity** - Being explicit about what you want

   - Use imperative form ("Create", "Analyze")
   - Be specific about quantities ("3-5 items", not "several")
   - Define success criteria clearly

2. **Context and Role-Playing** - Setting the stage for better results

   - Define your role ("You are an expert...")
   - Specify audience level
   - Provide background information

3. **Output Format Specification** - Never assume the format

   - Request specific formats (JSON, markdown, table)
   - Show exact structure
   - Include example outputs

4. **Examples and Few-Shot Prompting** - Teaching by example

   - One example: Basic format
   - Two examples: Patterns and edge cases
   - Three+ examples: Complex logic

5. **Constraints and Guardrails** - Define boundaries

   - Scope constraints ("Focus only on...")
   - Quality constraints ("Must be factually accurate")
   - Style constraints ("Use simple language")

6. **Iterative Refinement** - Improving through feedback

   - Write → Get response → Evaluate → Refine → Repeat
   - Adjust constraints based on results
   - Progressive clarity improvement

7. **Token Efficiency** - Optimizing for cost and speed

   - Remove redundancy
   - Use structure over explanation
   - Trust context

8. **Templates and Patterns** - Reusable prompt structures
   - Simple task template
   - Complex analysis template
   - Creative work template

**Word Count**: ~2,000-2,500 words
**Format**: Good vs bad examples throughout
**Audience**: AI agents and human users

### 2. Agent: Prompting

**File**: `agents/prompting.md`

Autonomous agent that enforces prompt best practices.

#### Capabilities

- **Refines instructions** using best practices
- **Validates quality** against standards
- **Suggests improvements** with explanations
- **Interactive approval** workflow
- **Applies changes** only when approved

#### Quality Standards

**Required**:

- Clear, specific description
- Explicit output format specification
- Example usage demonstrations

**Recommended**:

- Role definition ("You are...")
- Proper section headers
- Constraints and guardrails

#### Model & Performance

- **Model**: Claude Opus (maximum quality)
- **Tools**: Read, Write, Edit, Bash
- **Focus**: Quality over speed

### 3. Command: Command Builder

**File**: `commands/command-builder.md`

Interactive command generation tool with best practices integration.

#### Usage

```bash
/prompting:command-builder
```

#### Workflow Steps

1. **Specify** - Enter command name and purpose
2. **Refine** - Agent enhances using best practices
3. **Review** - Approve suggestions interactively
4. **Preview** - See complete generated command
5. **Confirm** - Save with overwrite protection
6. **Success** - View usage instructions

#### Generated Command Structure

```yaml
---
name: command-name                # Kebab-case identifier
description: Brief overview       # What it does
version: 0.1.0                   # Semantic version (auto)
allowed-tools: Read, Write       # Required tools
tags: [category, subcategory]    # Auto-generated tags
---

## Overview
[Clear explanation of what the command does]

## Usage
[How to invoke and what arguments it takes]

## Examples
[Real-world usage scenarios with input/output]

## Output Format
[Explicit specification of response structure]

## Notes
[Special considerations or limitations]
```

## Usage Examples

### Using the Skill

Ask Claude about prompt engineering:

```
"What are the key principles for writing effective prompts?"
"Show me examples of good vs bad prompts"
"How do I structure a prompt for better results?"
"Explain the importance of explicit output format"
```

Expected: Detailed guidance with examples and best practices.

### Using the Command Builder

#### Basic Usage

**User invokes:**

```bash
/prompting:command-builder
```

**Interactive workflow:**

1. Enter command name (e.g., `summarize`)
2. Enter command purpose (e.g., `Summarizes text into bullet points`)
3. Review agent-suggested improvements
4. Approve changes to generate the command
5. Confirm file creation in `.claude/commands/`

#### Simple Command Example

**User invokes:**

```bash
/prompting:command-builder
```

**Input:**

```text
Name: summarize
Purpose: Summarizes text into bullet points
```

**Generated command will include:**

- Role: "You are an expert summarizer"
- Output format: "Markdown bullet list"
- Examples: Sample summaries
- Constraints: "Keep each point under 25 words"

**Output:**
Command saved to `.claude/commands/summarize.md` and ready to use as `/summarize`

#### Complex Command Example

**User invokes:**

```bash
/prompting:command-builder
```

**Input:**

```text
Name: code-reviewer
Purpose: Reviews code and suggests improvements
```

**Generated command will include:**

- Role: "You are a senior code reviewer"
- Input format: "Paste code to review"
- Output format: "JSON with issues array"
- Examples: Before/after code reviews
- Tools: Read, Write, Bash

**Output:**
Command saved to `.claude/commands/code-reviewer.md` with full frontmatter and best practices

## Workflow

### Typical User Journey

```
1. User wants to create a custom command
   ↓
2. User runs /prompting:command-builder
   ↓
3. Provides: command name + purpose
   ↓
4. Prompting agent analyzes and suggests improvements
   ↓
5. User reviews and approves suggestions
   ↓
6. Command file generated with best practices
   ↓
7. File saved to .claude/commands/
   ↓
8. User can now invoke their custom command
```

### Agent Refinement Process

```
Input: Simple command purpose
  ↓
Analysis: Check against 8 principles
  ↓
Gaps Identified:
  - Missing output format
  - No examples
  - Unclear constraints
  ↓
Suggestions: "Add explicit format", "Include examples"
  ↓
User Review: Approve/modify/reject each suggestion
  ↓
Apply Changes: Generate refined command
  ↓
Validate: Confirm all required fields present
  ↓
Output: Complete command file
```

## Best Practices

### For Creating Effective Prompts

1. **Be Specific**

   - ❌ "Help with code"
   - ✅ "Identify unused variables and suggest removal"

2. **Provide Context**

   - ❌ "Analyze this"
   - ✅ "You are a security expert. Analyze for vulnerabilities"

3. **Specify Format**

   - ❌ "List the issues"
   - ✅ "Return a JSON array with {severity, line, description}"

4. **Include Examples**

   - Show what good output looks like
   - Include edge cases
   - Demonstrate the expected structure

5. **Define Constraints**
   - "Keep responses under 500 words"
   - "Focus on security and performance"
   - "Don't mention legacy systems"

### For Using the Command Builder

1. **Think about your use case** - Be clear on what the command should do
2. **Let the agent help** - Approve suggestions for better results
3. **Test your command** - Invoke it and verify behavior
4. **Iterate** - Edit and improve based on actual usage

## Configuration

### Plugin Settings

The plugin works out-of-the-box with no configuration required.

### Optional Customization

To customize the command output directory:

1. Edit `.claude/prompting.local.md` (create if needed)
2. Add your configuration preferences
3. Restart Claude Code

### Generated Command Storage

By default, commands are saved to:

```
.claude/commands/[command-name].md
```

To verify creation:

```bash
ls -la .claude/commands/
```

## Troubleshooting

### Skill Not Loading

- Verify plugin is installed: `cc --version`
- Restart Claude Code after installation
- Check that prompt matches trigger phrases

### Command Builder Issues

| Issue               | Solution                                   |
| ------------------- | ------------------------------------------ |
| Name has spaces     | Automatically converted to kebab-case      |
| Purpose too vague   | Agent will suggest clarifications          |
| File exists         | You'll be asked to confirm overwrite       |
| Command not working | Edit `.claude/commands/[name].md` directly |

### Agent Suggestions Not Appearing

1. Verify Opus model access
2. Check internet connectivity
3. Restart Claude Code
4. Try with more detailed purpose description

## Advanced Usage

### Batch Command Creation

Create multiple commands in sequence:

```bash
/prompting:command-builder
# Create first command, repeat for others
```

### Integrating with Existing Commands

1. Use command-builder to create new commands
2. Edit `.claude/commands/[name].md` for fine-tuning
3. Add your custom logic and examples
4. Share with team via version control

### Extending the Skill

The prompt-best-practices skill can be referenced in your own commands:

```markdown
## Best Practices

This command applies the principles from the prompt-best-practices skill:

- Clarity and specificity in your request
- Explicit output format requirement
- Relevant context and role assignment
```

## Performance Notes

- **Skill activation**: Immediate (locally available)
- **Agent processing**: 10-30 seconds (depends on command complexity)
- **Command generation**: 15-60 seconds (includes agent refinement)
- **File I/O**: < 1 second

## Security

- ✅ No external API calls
- ✅ All processing local to Claude Code
- ✅ No data transmission outside your environment
- ✅ Generated commands follow security best practices
- ✅ No sensitive data storage in plugin files

## Contributing

To improve this plugin:

1. Test the skill and command builder
2. Suggest improvements via issues
3. Share command templates you've created
4. Help improve documentation

## Related Resources

- **Official Docs**: <https://code.claude.com/>
- **Prompt Engineering Guide**: <https://platform.openai.com/docs/guides/prompt-engineering>
- **Claude Documentation**: <https://docs.anthropic.com/>

## License

MIT - See repository LICENSE file

---

## Support

For questions or issues:

- Check the prompt-best-practices skill documentation
- Review examples in generated command files
- Test with the command-builder tool
- Refer to Claude Code documentation

## Changelog

### Version 0.1.0 (2025-12-22)

**Initial Release**

- ✅ Comprehensive prompt best practices skill
- ✅ Autonomous prompting agent
- ✅ Interactive command builder
- ✅ Complete documentation
- ✅ 8 core principles covered
- ✅ Good vs bad examples throughout

**Future Enhancements**

- Command template library
- Batch command generation
- Prompt testing framework
- Performance metrics
- Integration with version control

---

**Last Updated**: 2025-12-22
**Version**: 0.1.0
**Maintainer**: Javier Alvarez
**License**: MIT

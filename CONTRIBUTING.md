# Contributing to Hyaish Agents

Thank you for your interest in contributing! This document provides guidelines for contributing to the Hyaish Agents plugin.

## How to Contribute

### Reporting Issues

1. Check [existing issues](https://github.com/eco-ansible-content/agentic-workflows/issues) first
2. Create a new issue with:
   - Clear title
   - Detailed description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Environment details (OS, Claude Code version)

### Suggesting Features

1. Open a [GitHub Discussion](https://github.com/eco-ansible-content/agentic-workflows/discussions)
2. Describe:
   - Use case
   - Proposed solution
   - Alternatives considered
   - Why it benefits the project

### Adding a New Swarm

To contribute a new agent swarm:

1. **Fork the repository**

2. **Create swarm directory**:
   ```bash
   cd claude/
   mkdir my-new-swarm
   ```

3. **Add required structure**:
   ```
   my-new-swarm/
   ├── agents/              # Agent definitions (.md files)
   ├── skills/              # Slash command skill
   ├── knowledge/           # Patterns, examples
   ├── resources/           # Guides, references
   └── README.md            # Swarm documentation
   ```

4. **Update plugin configuration**:
   - Add swarm to `claude/package.json` (claudePlugin.swarms section)
   - Update `claude/verify.sh` to check your swarm
   - Update `claude/README.md` with swarm info

5. **Document your swarm**:
   - Clear README.md
   - Usage examples
   - Agent descriptions

6. **Test thoroughly**:
   ```bash
   cd claude
   ./verify.sh
   ```

7. **Submit Pull Request**:
   - Clear description of what the swarm does
   - Why it's useful
   - Examples of usage

### Improving Existing Swarms

1. **Small improvements** (typos, docs): Direct PR
2. **Larger changes** (new agents, patterns): Discuss in issue first
3. **Breaking changes**: Must discuss with maintainers first

### Code Style

#### Agent Definitions

```markdown
---
name: agent-name
description: Brief description of agent role
model: sonnet  # or opus
---

# Agent Title

Clear description of what this agent does.

## Input

What this agent receives.

## Process

How it works.

## Output

What it produces.
```

#### Documentation

- Use clear, concise language
- Include examples
- Keep formatting consistent
- Update table of contents if needed

### Pull Request Process

1. **Fork** the repository
2. **Create branch**: `git checkout -b feature/my-new-swarm`
3. **Make changes**
4. **Test**: Run `./verify.sh`
5. **Commit**: Use clear commit messages
6. **Push**: `git push origin feature/my-new-swarm`
7. **Open PR**: Include description, screenshots if applicable

### Commit Messages

Use conventional commits format:

```
type(scope): subject

body

footer
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

Examples:
```
feat(ansible-swarm): add terraform module pattern

Added new pattern for Terraform module development.
Includes example implementation and tests.

Closes #123
```

## Development Setup

### Prerequisites

- Claude Code (CLI, desktop, or web)
- Git
- Bash (for scripts)

### Local Development

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/agentic-workflows.git
cd agentic-workflows

# Create symlink for testing
ln -s $(pwd)/claude ~/.claude/agents/agentic-workflows-dev

# Make changes in claude/

# Test
cd claude
./verify.sh

# Test with Claude Code
/ansible-collection-swarm --help
```

## Testing

### Verification Script

Always run before submitting PR:
```bash
cd claude
./verify.sh
```

Should output:
```
✅ Plugin ready to use!
Plugin infrastructure: 3/3
Ansible Collection Swarm: 17/17
[Your swarm]: X/X
```

### Manual Testing

Test your changes with real use cases:
```bash
# Test new swarm
/my-new-swarm EPIC-XXX

# Test agent directly
Agent({
  subagent_type: "agentic-workflows/my-new-swarm:my-agent",
  prompt: "Test task"
})
```

## Documentation Requirements

Every new swarm must include:

1. **README.md** - Overview, features, examples
2. **QUICKSTART.md** - 5-minute getting started guide
3. **Agent descriptions** - Each agent clearly documented
4. **Usage examples** - Real-world scenarios
5. **Update root README.md** - Add to Available Swarms section

## Code Review

Maintainers will review for:
- ✅ Code quality
- ✅ Documentation completeness
- ✅ Test coverage
- ✅ Consistency with existing swarms
- ✅ Performance implications
- ✅ Security considerations

## Questions?

- **General questions**: [GitHub Discussions](https://github.com/eco-ansible-content/agentic-workflows/discussions)
- **Bug reports**: [GitHub Issues](https://github.com/eco-ansible-content/agentic-workflows/issues)
- **Feature requests**: [GitHub Discussions](https://github.com/eco-ansible-content/agentic-workflows/discussions)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Hyaish Agents! 🎉

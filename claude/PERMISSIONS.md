# Permissions

This plugin requires autonomous operation with zero permission prompts.

## Auto-Approved Tools

All tools and commands are pre-approved for autonomous operation:

- `Bash(*)` - All bash commands
- `Read` - All file reading
- `Write` - All file writing  
- `Edit` - All file editing
- `WebSearch` - All web searches
- `WebFetch` - All web fetches
- `Agent` - All agent invocations
- `Skill` - All skill invocations

## Rationale

The Hyaish Agents swarm is designed for autonomous operation:
- Operates in isolated workspace (`~/agentic-workflow-collections/`)
- All changes tracked in git (reversible)
- Test environment is non-production
- Enhancement mode uses branch/fork/PR workflow (user reviews before merge)
- Agent instructions explicitly forbid destructive operations

## Security

Safe because:
1. Limited scope to project directory
2. Git-based workflow (all changes reversible)
3. Test environment separate from production
4. User reviews PRs before deployment
5. Agent instructions prevent destructive operations

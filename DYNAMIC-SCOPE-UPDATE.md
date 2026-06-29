# Dynamic Jira Ticket Scope Support

## What Changed

The Agentic Workflows swarm now supports **dynamic scope** based on Jira ticket type, making it much more flexible for different workflow patterns.

## Supported Ticket Types

### 1. Single Task/Story
```bash
/ansible-collection-swarm TASK-1234
```
- **Scope**: Build ONLY the module described in that task
- **Use case**: Quick single-module additions
- **Example**: "Create scvmm_vm_snapshot module" → builds just that one module

### 2. Epic
```bash
/ansible-collection-swarm EPIC-5678
```
- **Scope**: Build ALL modules from all tasks within the Epic
- **Use case**: Feature-complete collections for a platform
- **Example**: "Build SCVMM collection" Epic with 15 subtasks → builds all 15 modules

### 3. ANSTRAT (Initiative)
```bash
/ansible-collection-swarm ANSTRAT-100
```
- **Scope**: Build ALL modules from ALL Epics within the ANSTRAT
- **Use case**: Large multi-platform initiatives
- **Example**: "Windows Automation Platform" with 3 Epics → builds all modules across all Epics

## How It Works

### Automatic Detection
The **Jira Ingestion Specialist** automatically:
1. Fetches the ticket using `jira-rh issue <TICKET-KEY>`
2. Detects the ticket type from the `Type:` field
3. Adjusts scope accordingly:
   - **Task** → Extract 1 module from this ticket
   - **Epic** → Fetch all subtasks, extract modules from each
   - **ANSTRAT** → Fetch all child Epics, then all subtasks in each Epic

### No User Action Required
The user just provides the Jira ticket key - the swarm figures out the rest!

## Benefits

✅ **Flexible**: Works at any granularity (single module to entire initiatives)  
✅ **Intelligent**: Auto-detects scope based on ticket structure  
✅ **Traceable**: Module backlog includes source ticket for each module  
✅ **Efficient**: Only builds what's in scope

## Migration Notes

### Before (Old Behavior)
- Only supported Epics
- If given a Task, would try to find and build the entire parent Epic
- Users had to create Epics even for single modules

### After (New Behavior)
- Supports Task, Epic, or ANSTRAT
- Scope exactly matches ticket type
- No forced escalation to Epic level

## Updated Documentation

- ✅ README examples updated
- ✅ jira-ingestion-specialist agent updated
- ✅ lead-architect agent updated
- ✅ Usage examples show all three types

## Real-World Examples

### Quick Fix: Single Module
```bash
# User creates task: "Add scvmm_vm_snapshot module"
/ansible-collection-swarm WINOPS-1234

# Result: Just that one module built and tested
```

### Feature: Complete Collection
```bash
# Epic: "Build complete SCVMM collection" (15 tasks)
/ansible-collection-swarm EPIC-5000

# Result: All 15 modules built as a complete collection
```

### Initiative: Multi-Platform Automation
```bash
# ANSTRAT: "Windows Automation" (3 Epics: SCVMM, Hyper-V, Exchange)
/ansible-collection-swarm ANSTRAT-100

# Result: All modules across all 3 platforms
```

## Technical Details

### Ticket Type Detection
```bash
$ jira-rh issue TASK-1234
Type: Task
Summary: Create scvmm_vm module
→ Scope: Single module

$ jira-rh issue EPIC-5000  
Type: Epic
Subtasks: TASK-5001, TASK-5002, TASK-5003
→ Scope: All 3 modules

$ jira-rh issue ANSTRAT-100
Type: Initiative
Child Epics: EPIC-5000, EPIC-6000
→ Scope: All modules from both Epics
```

### Module Backlog Traceability
```markdown
# Module Backlog

**Source**: EPIC-5000 (Epic)
**Scope**: All modules from Epic EPIC-5000

## Modules
- [ ] scvmm_vm - VM management [Source: TASK-5001]
- [ ] scvmm_vm_info - VM information gathering [Source: TASK-5002]
- [ ] scvmm_vm_snapshot - VM snapshot management [Source: TASK-5003]
```

---

**Version**: 1.1.0  
**Date**: 2026-06-29

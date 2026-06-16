# Collection Detection Strategy

## Overview

The Lead Architect intelligently detects whether to operate in **Full Build** or **Enhancement** mode by searching for existing collections in multiple locations where real developers work.

## Detection Flow

```
User invokes: "Build collection from EPIC-XXX"
              or "Enhance microsoft.scvmm"
                        ↓
        ┌───────────────────────────────┐
        │ Extract namespace & name      │
        │ from Epic/user prompt         │
        └───────────────┬───────────────┘
                        ↓
        ┌───────────────────────────────┐
        │ Check 4 Locations (in order): │
        │ 1. Current directory           │
        │ 2. Swarm workspace             │
        │ 3. Ansible collections path    │
        │ 4. User-specified path         │
        └───────────────┬───────────────┘
                        ↓
                ┌───────┴────────┐
                │ Found?         │
                └───┬────────┬───┘
                    │        │
                  Yes       No
                    │        │
                    ↓        ↓
        ┌───────────────┐   ┌────────────────┐
        │ Enhancement   │   │ Full Build     │
        │ Mode          │   │ Mode           │
        └───────────────┘   └────────────────┘
```

## Location Search Priority

### Location 1: Current Directory (Highest Priority)

**Why first**: Developers typically clone/fork repos and work in them.

**Check**:
```bash
if [ -f "./galaxy.yml" ]; then
  CURRENT_NS=$(grep "^namespace:" galaxy.yml | awk '{print $2}')
  CURRENT_NAME=$(grep "^name:" galaxy.yml | awk '{print $2}')
  
  if [ "$CURRENT_NS" = "$NAMESPACE" ] && [ "$CURRENT_NAME" = "$NAME" ]; then
    COLLECTION_PATH="$(pwd)"
    DETECTION_METHOD="current_directory"
  fi
fi
```

**Example**:
```bash
# Developer scenario
$ cd ~/projects/ansible-collections/microsoft-scvmm/
$ ls
galaxy.yml  plugins/  tests/  README.md

$ claude-code --agent lead-architect.md "Add modules from EPIC-5678"

✅ EXISTING COLLECTION DETECTED
📦 Collection: microsoft.scvmm
📁 Location: /Users/dev/projects/ansible-collections/microsoft-scvmm
🔍 Detection: current_directory
🔧 Mode: ENHANCEMENT (add new modules)
💡 Working in place - no file copying needed
```

**Advantages**:
- No file copying needed
- Preserves existing git history
- Developer's IDE already configured
- Can immediately test changes

---

### Location 2: Swarm Workspace

**Why second**: Collections previously built by the swarm live here.

**Check**:
```bash
SWARM_PATH="$HOME/agentic-workflow-collections/$NAMESPACE/$NAME"
if [ -d "$SWARM_PATH" ] && [ -f "$SWARM_PATH/galaxy.yml" ]; then
  COLLECTION_PATH="$SWARM_PATH"
  DETECTION_METHOD="swarm_workspace"
fi
```

**Example**:
```bash
# Swarm-managed collection
$ pwd
/Users/dev/anywhere

$ claude-code --agent lead-architect.md "Enhance microsoft.scvmm from EPIC-9999"

✅ EXISTING COLLECTION DETECTED
📦 Collection: microsoft.scvmm
📁 Location: /Users/dev/agentic-workflow-collections/microsoft/scvmm
🔍 Detection: swarm_workspace
🔧 Mode: ENHANCEMENT
```

**Advantages**:
- Centralized location for all swarm-built collections
- Consistent structure
- Easy to find

---

### Location 3: Ansible Collections Path

**Why third**: Collections installed via `ansible-galaxy install` live here.

**Check**:
```bash
ANSIBLE_PATH="$HOME/.ansible/collections/ansible_collections/$NAMESPACE/$NAME"
if [ -d "$ANSIBLE_PATH" ] && [ -f "$ANSIBLE_PATH/galaxy.yml" ]; then
  COLLECTION_PATH="$ANSIBLE_PATH"
  DETECTION_METHOD="ansible_collections"
fi
```

**Example**:
```bash
# Installed collection
$ ansible-galaxy collection install microsoft.scvmm

$ claude-code --agent lead-architect.md "Enhance microsoft.scvmm"

✅ EXISTING COLLECTION DETECTED
📦 Collection: microsoft.scvmm
📁 Location: /Users/dev/.ansible/collections/ansible_collections/microsoft/scvmm
🔍 Detection: ansible_collections
⚠️  READ-ONLY LOCATION DETECTED

Where should I work?
  A) Current directory (if you've cloned the repo here)
  B) Clone to swarm workspace (~/agentic-workflow-collections/microsoft/scvmm)
  C) Specify custom location
```

**Important**: This is a **read-only detection** - prompts user to choose working location because:
- Modifying installed collections directly is bad practice
- Changes get overwritten on reinstall
- Should work in development location instead

---

### Location 4: User-Specified Path

**Why last**: Fallback for non-standard locations.

**Check**:
```bash
# Extract from user prompt: "Enhance collection at ~/my-projects/scvmm-fork/"
USER_PATH=$(extract_path_from_user_prompt)

if [ -n "$USER_PATH" ] && [ -d "$USER_PATH" ] && [ -f "$USER_PATH/galaxy.yml" ]; then
  COLLECTION_PATH="$USER_PATH"
  DETECTION_METHOD="user_specified"
fi
```

**Example**:
```bash
$ claude-code --agent lead-architect.md "Enhance collection at ~/dev/forks/scvmm-ansible/"

✅ EXISTING COLLECTION DETECTED
📦 Collection: microsoft.scvmm
📁 Location: /Users/dev/dev/forks/scvmm-ansible
🔍 Detection: user_specified
🔧 Mode: ENHANCEMENT
```

**Advantages**:
- Supports any directory structure
- Developer has full control
- Works with symlinks, network drives, etc.

---

## Decision Matrix

| Scenario | Location 1 | Location 2 | Location 3 | Location 4 | Result | Action |
|----------|-----------|-----------|-----------|-----------|--------|--------|
| Developer in cloned repo | ✅ Match | - | - | - | Enhancement | Work in current dir |
| Developer anywhere, swarm built before | ❌ No match | ✅ Match | - | - | Enhancement | Work in swarm workspace |
| Collection installed via galaxy | ❌ No match | ❌ No match | ✅ Match | - | Enhancement | **Ask user** where to work |
| User specifies custom path | ❌ No match | ❌ No match | ❌ No match | ✅ Match | Enhancement | Work in custom path |
| Multiple locations found | ✅ Match | ✅ Match | - | - | Enhancement | **Ask user** which to use |
| No matches anywhere | ❌ No match | ❌ No match | ❌ No match | ❌ No match | Full Build | Create in swarm workspace |

---

## Question 3: When Asked

### Scenario A: Read-Only Location (ansible_collections)

```
Collection 'microsoft.scvmm' found in Ansible installation directory.
This is a read-only location. Where should I work?

Options:
  1. Current directory: /Users/dev/projects/scvmm-dev/
     (Choose if you've cloned the repo here)
  
  2. Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/
     (Choose for centralized swarm management)
  
  3. Custom path: [Specify in "Other" field]
     (Choose if collection is in a different location)
```

### Scenario B: Multiple Locations

```
Collection 'microsoft.scvmm' found in multiple locations:
  - /Users/dev/projects/ansible-collections/microsoft-scvmm/
  - /Users/dev/agentic-workflow-collections/microsoft/scvmm/

Which should I use?

Options:
  1. Current directory: /Users/dev/projects/ansible-collections/microsoft-scvmm/
  
  2. Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/
  
  3. Custom path: [Specify in "Other" field]
```

### Scenario C: Ambiguous Current Directory

```
Current directory contains a galaxy.yml but for a different collection:
  Current: namespace: cisco, name: ios
  Requested: microsoft.scvmm

Where is the microsoft.scvmm collection?

Options:
  1. Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/ (if exists)
  
  2. Custom path: [Specify in "Other" field]
  
  3. Not found - create new (Full Build mode)
```

---

## Smart Detection Examples

### Example 1: Developer Working on Fork

```bash
# Developer has forked and cloned
$ cd ~/projects/my-forks/ansible-scvmm-collection/
$ git remote -v
origin  https://github.com/myusername/ansible-scvmm-collection.git (fetch)
upstream https://github.com/microsoft/ansible-scvmm-collection.git (fetch)

$ ls
galaxy.yml  plugins/  tests/  README.md

$ cat galaxy.yml
namespace: microsoft
name: scvmm
version: 1.0.0

# Invoke swarm
$ claude-code --agent lead-architect.md "Add SCVMM network modules from EPIC-5678"

# Detection
✅ Location 1 (current_directory) matches!
📁 Path: /Users/dev/projects/my-forks/ansible-scvmm-collection
🔧 Mode: ENHANCEMENT
💡 Working in your forked repo - changes ready to commit and PR
```

**No Question 3 asked** - clear single location match.

---

### Example 2: Developer Not in Collection Directory

```bash
# Developer in different directory
$ pwd
/Users/dev/scripts

# Collection exists in swarm workspace
$ ls ~/agentic-workflow-collections/microsoft/scvmm/
galaxy.yml  plugins/  tests/  README.md

# Invoke swarm
$ claude-code --agent lead-architect.md "Enhance microsoft.scvmm from EPIC-9999"

# Detection
❌ Location 1 (current_directory): No galaxy.yml here
✅ Location 2 (swarm_workspace) matches!
📁 Path: /Users/dev/agentic-workflow-collections/microsoft/scvmm
🔧 Mode: ENHANCEMENT
```

**No Question 3 asked** - single location match.

---

### Example 3: Collection Installed via Galaxy

```bash
# Developer has installed collection
$ ansible-galaxy collection install microsoft.scvmm

# Now wants to enhance it
$ cd ~/projects/scvmm-dev/  # Developer's working directory
$ claude-code --agent lead-architect.md "Add modules to microsoft.scvmm"

# Detection
❌ Location 1 (current_directory): galaxy.yml not here
❌ Location 2 (swarm_workspace): Doesn't exist
✅ Location 3 (ansible_collections) matches!
⚠️  Read-only location!

# Question 3 ASKED
Where should I work?
  A) Current directory: /Users/dev/projects/scvmm-dev/ (clone here)
  B) Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/
  C) Custom path: ___________

User chooses: A (current directory)

# Result
🔄 Copying collection to current directory for development
📁 Working path: /Users/dev/projects/scvmm-dev/
🔧 Mode: ENHANCEMENT
💡 Original in ansible_collections remains untouched
```

---

### Example 4: Explicit Path in Prompt

```bash
$ claude-code --agent lead-architect.md "Enhance collection at ~/dev/ansible/scvmm-custom/"

# Detection
🔍 User specified path: ~/dev/ansible/scvmm-custom/
✅ Location 4 (user_specified) matches!
📁 Path: /Users/dev/dev/ansible/scvmm-custom
🔧 Mode: ENHANCEMENT
```

**No Question 3 asked** - user explicitly specified location.

---

### Example 5: Multiple Matches (Ambiguous)

```bash
# Collection exists in TWO places
$ ls ~/agentic-workflow-collections/microsoft/scvmm/
galaxy.yml  plugins/  tests/

$ cd ~/projects/scvmm-fork/
$ ls
galaxy.yml  plugins/  tests/

# Invoke swarm from fork directory
$ claude-code --agent lead-architect.md "Add modules from EPIC-5678"

# Detection
✅ Location 1 (current_directory) matches!
✅ Location 2 (swarm_workspace) also matches!
⚠️  Multiple locations found!

# Question 3 ASKED
Collection found in multiple locations:
  1. Current directory: /Users/dev/projects/scvmm-fork/
  2. Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/

Which should I use?

User chooses: 1 (current directory - the fork)

# Result
📁 Working path: /Users/dev/projects/scvmm-fork/
🔧 Mode: ENHANCEMENT
💡 Other location ignored
```

---

## Benefits of Multi-Location Detection

### 1. Works Like Developers Expect
- Detects cloned repos automatically
- No need to copy files around
- Respects developer's directory structure

### 2. Safe Defaults
- Never modifies ansible_collections directly (asks first)
- Prefers current directory (developer is likely there for a reason)
- Falls back to swarm workspace if ambiguous

### 3. Flexible
- Supports forks
- Supports symlinks
- Supports network drives
- Supports any custom layout

### 4. Intelligent
- Only asks Question 3 when truly needed
- Auto-detects unambiguous cases
- Explains why asking when it does

---

## Implementation Notes

### Parsing User Prompts for Paths

```bash
# Extract path patterns from user input
extract_path_from_user_prompt() {
  local prompt="$1"
  
  # Pattern 1: "at /path/to/collection"
  if [[ "$prompt" =~ at[[:space:]]+([~/][^[:space:]]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    return
  fi
  
  # Pattern 2: "in /path/to/collection"
  if [[ "$prompt" =~ in[[:space:]]+([~/][^[:space:]]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    return
  fi
  
  # Pattern 3: "from /path/to/collection"
  if [[ "$prompt" =~ from[[:space:]]+([~/][^[:space:]]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    return
  fi
}
```

### Verifying Collection Match

```bash
verify_collection_match() {
  local path="$1"
  local expected_ns="$2"
  local expected_name="$3"
  
  if [ ! -f "$path/galaxy.yml" ]; then
    return 1  # Not a collection
  fi
  
  local actual_ns=$(grep "^namespace:" "$path/galaxy.yml" | awk '{print $2}')
  local actual_name=$(grep "^name:" "$path/galaxy.yml" | awk '{print $2}')
  
  if [ "$actual_ns" = "$expected_ns" ] && [ "$actual_name" = "$expected_name" ]; then
    return 0  # Match!
  else
    return 1  # Wrong collection
  fi
}
```

---

## Summary

**Old approach**:
- Only checked `~/agentic-workflow-collections/<namespace>/<name>/`
- Didn't work for developers with cloned repos
- Required manual file copying

**New approach**:
- Checks 4 locations in priority order
- Works seamlessly with cloned/forked repos
- Only asks for clarification when truly ambiguous
- Respects developer workflows

**Result**: The swarm now works naturally in real-world development scenarios! 🎯

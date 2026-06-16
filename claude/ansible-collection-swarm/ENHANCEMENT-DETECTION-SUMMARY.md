# Enhancement Detection - Summary

## The Problem We Solved

**Original approach** (too limited):
```bash
# Only checked one location
COLLECTION_PATH="$HOME/agentic-workflow-collections/$NAMESPACE/$NAME"
if [ -d "$COLLECTION_PATH" ]; then
  WORKFLOW_MODE="enhancement"
fi
```

**Issues**:
- ❌ Doesn't find developer's cloned repos
- ❌ Doesn't find forked collections
- ❌ Requires manual file copying
- ❌ Breaks git history
- ❌ Doesn't work with real-world workflows

---

## New Approach (Real-World Ready)

### Multi-Location Search (Priority Order)

```
1. Current Directory          → Developer working in cloned repo
   └─ Check: ./galaxy.yml with matching namespace/name
   
2. Swarm Workspace           → Previously built by swarm
   └─ Check: ~/agentic-workflow-collections/<namespace>/<name>/
   
3. Ansible Collections Path  → Installed via ansible-galaxy
   └─ Check: ~/.ansible/collections/ansible_collections/<namespace>/<name>/
   
4. User-Specified Path       → Custom location from user prompt
   └─ Extract: "at /path/to/collection" from user input
```

---

## Smart Question Logic

### Question 3 Asked ONLY When:

**Scenario A**: Multiple locations found
```
Found in:
  - ~/projects/ansible-collections/microsoft-scvmm/
  - ~/agentic-workflow-collections/microsoft/scvmm/

Ask: Which should I use?
```

**Scenario B**: Read-only location (ansible_collections)
```
Found in: ~/.ansible/collections/ansible_collections/microsoft/scvmm/

Ask: This is read-only. Where should I work instead?
```

**Scenario C**: Ambiguous current directory
```
Current dir has: cisco.ios collection
But user requested: microsoft.scvmm

Ask: Where is microsoft.scvmm?
```

### Question 3 NOT Asked When:

**Scenario D**: Clear current directory match
```
Current dir: ~/projects/scvmm-fork/
galaxy.yml: namespace: microsoft, name: scvmm

Action: Use current directory automatically
```

**Scenario E**: Single swarm workspace match
```
Current dir: anywhere
Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/ exists

Action: Use swarm workspace automatically
```

**Scenario F**: User explicitly specified path
```
User: "Enhance collection at ~/my-custom-path/"

Action: Use specified path directly
```

---

## Real-World Scenarios

### Scenario 1: Developer's Fork (Most Common)

**Setup**:
```bash
$ git clone https://github.com/myusername/ansible-scvmm.git
$ cd ansible-scvmm/
```

**Invocation**:
```bash
$ claude-code --agent lead-architect.md "Add modules from EPIC-5678"
```

**Detection**:
```
🔍 Phase 0: Collection Detection
  ✅ Location 1 (current directory): MATCH
     Path: /Users/dev/ansible-scvmm
     galaxy.yml: namespace: microsoft, name: scvmm
  
  Decision: Enhancement Mode
  Working path: /Users/dev/ansible-scvmm (in place)
```

**Questions**:
- Q1: Test environment? → User answers
- Q2: Delivery target? → User answers
- Q3: ❌ NOT ASKED (clear single match)

**Result**: Works directly in cloned repo, ready for PR

---

### Scenario 2: Swarm-Built Collection

**Setup**:
```bash
# Previously built by swarm
$ ls ~/agentic-workflow-collections/microsoft/scvmm/
galaxy.yml  plugins/  tests/

# Developer in different directory
$ cd ~/scripts/
```

**Invocation**:
```bash
$ claude-code --agent lead-architect.md "Enhance microsoft.scvmm from EPIC-9999"
```

**Detection**:
```
🔍 Phase 0: Collection Detection
  ❌ Location 1 (current directory): No galaxy.yml
  ✅ Location 2 (swarm workspace): MATCH
     Path: ~/agentic-workflow-collections/microsoft/scvmm
  
  Decision: Enhancement Mode
  Working path: ~/agentic-workflow-collections/microsoft/scvmm
```

**Questions**:
- Q1: Test environment? → User answers
- Q2: Delivery target? → User answers  
- Q3: ❌ NOT ASKED (single match)

**Result**: Works in swarm workspace

---

### Scenario 3: Installed Collection

**Setup**:
```bash
$ ansible-galaxy collection install microsoft.scvmm
$ cd ~/projects/my-work/
```

**Invocation**:
```bash
$ claude-code --agent lead-architect.md "Add features to microsoft.scvmm"
```

**Detection**:
```
🔍 Phase 0: Collection Detection
  ❌ Location 1 (current directory): No galaxy.yml
  ❌ Location 2 (swarm workspace): Doesn't exist
  ✅ Location 3 (ansible_collections): MATCH
     Path: ~/.ansible/collections/ansible_collections/microsoft/scvmm
  ⚠️  READ-ONLY LOCATION!
```

**Questions**:
- Q1: Test environment? → User answers
- Q2: Delivery target? → User answers
- Q3: ✅ ASKED! (read-only location)
  ```
  Collection found in Ansible installation directory (read-only).
  Where should I work?
  
  A) Current directory: ~/projects/my-work/ (copy here)
  B) Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/
  C) Custom path: ___________
  ```

**User selects**: Option A (current directory)

**Result**: Collection copied to ~/projects/my-work/, ready for development

---

### Scenario 4: Explicit Path

**Invocation**:
```bash
$ claude-code --agent lead-architect.md "Enhance collection at ~/dev/forks/scvmm-ansible/"
```

**Detection**:
```
🔍 Phase 0: Collection Detection
  🎯 User specified path: ~/dev/forks/scvmm-ansible/
  ✅ Location 4 (user-specified): MATCH
     Path: /Users/dev/dev/forks/scvmm-ansible
  
  Decision: Enhancement Mode
  Working path: /Users/dev/dev/forks/scvmm-ansible
```

**Questions**:
- Q1: Test environment? → User answers
- Q2: Delivery target? → User answers
- Q3: ❌ NOT ASKED (user explicitly specified)

**Result**: Works at user-specified path

---

### Scenario 5: Multiple Locations (Ambiguous)

**Setup**:
```bash
# Collection exists in TWO places
$ ls ~/projects/scvmm-fork/
galaxy.yml  plugins/  tests/

$ ls ~/agentic-workflow-collections/microsoft/scvmm/
galaxy.yml  plugins/  tests/

# Developer in fork directory
$ cd ~/projects/scvmm-fork/
```

**Invocation**:
```bash
$ claude-code --agent lead-architect.md "Add modules from EPIC-5678"
```

**Detection**:
```
🔍 Phase 0: Collection Detection
  ✅ Location 1 (current directory): MATCH
     Path: ~/projects/scvmm-fork
  ✅ Location 2 (swarm workspace): ALSO MATCH
     Path: ~/agentic-workflow-collections/microsoft/scvmm
  ⚠️  MULTIPLE MATCHES!
```

**Questions**:
- Q1: Test environment? → User answers
- Q2: Delivery target? → User answers
- Q3: ✅ ASKED! (multiple locations)
  ```
  Collection found in multiple locations:
    1. Current directory: ~/projects/scvmm-fork/
    2. Swarm workspace: ~/agentic-workflow-collections/microsoft/scvmm/
  
  Which should I use?
  
  A) Current directory (likely your active work)
  B) Swarm workspace
  C) Custom path: ___________
  ```

**User selects**: Option A (current directory - the fork)

**Result**: Works in ~/projects/scvmm-fork/, other location ignored

---

## Benefits

### ✅ Works Like Developers Expect

**Before**:
```bash
# Manual workflow
$ git clone repo
$ cd repo
$ cp -r ~/agentic-workflow-collections/microsoft/scvmm/* .
$ # Lose git history, messy merge
```

**After**:
```bash
# Automatic workflow
$ git clone repo
$ cd repo
$ claude-code --agent lead-architect.md "Add modules..."
# Works in place! ✨
```

### ✅ Supports All Workflows

- **Forks**: ✅ Detected automatically
- **Clones**: ✅ Detected automatically
- **Swarm-built**: ✅ Detected automatically
- **Installed collections**: ✅ Detected with guidance
- **Custom paths**: ✅ Supported via explicit specification

### ✅ Safe Defaults

- Never modifies read-only ansible_collections without asking
- Prefers current directory (developer likely there for a reason)
- Only asks when truly ambiguous
- Clear explanations when asking

### ✅ Minimal Questions

Most common case (developer in cloned repo):
- 2 questions only (test env + delivery)
- No Question 3 needed

Only when ambiguous:
- 3 questions (adds location choice)

---

## Implementation Details

### Detection Code (Simplified)

```bash
detect_collection_location() {
  local namespace="$1"
  local name="$2"
  local user_prompt="$3"
  
  # Priority 1: Current directory
  if [ -f "./galaxy.yml" ]; then
    local ns=$(grep "^namespace:" galaxy.yml | awk '{print $2}')
    local nm=$(grep "^name:" galaxy.yml | awk '{print $2}')
    if [ "$ns" = "$namespace" ] && [ "$nm" = "$name" ]; then
      echo "$(pwd)|current_directory"
      return 0
    fi
  fi
  
  # Priority 2: Swarm workspace
  local swarm_path="$HOME/agentic-workflow-collections/$namespace/$name"
  if [ -d "$swarm_path" ] && [ -f "$swarm_path/galaxy.yml" ]; then
    echo "$swarm_path|swarm_workspace"
    return 0
  fi
  
  # Priority 3: Ansible collections
  local ansible_path="$HOME/.ansible/collections/ansible_collections/$namespace/$name"
  if [ -d "$ansible_path" ] && [ -f "$ansible_path/galaxy.yml" ]; then
    echo "$ansible_path|ansible_collections|READ_ONLY"
    return 0
  fi
  
  # Priority 4: User-specified
  local custom_path=$(extract_path_from_prompt "$user_prompt")
  if [ -n "$custom_path" ] && [ -f "$custom_path/galaxy.yml" ]; then
    echo "$custom_path|user_specified"
    return 0
  fi
  
  # Not found - new collection
  echo "NEW|full_build"
  return 1
}
```

---

## Summary

**Old**: Check one location, require manual copying  
**New**: Check 4 locations intelligently, work in place

**Old**: Always ask same questions  
**New**: Ask Question 3 only when needed

**Old**: Doesn't work with developer workflows  
**New**: Built for how developers actually work

**Result**: Real-world ready! 🎯

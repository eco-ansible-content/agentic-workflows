# Insights - Collective Intelligence Repository

**Purpose**: Captures sanitized learnings from all agent runs to continuously improve swarm intelligence.

## How It Works

### 1. During Runs
- `learning-evolution-specialist` captures lessons from successes and failures
- Lessons are sanitized (no customer names, IPs, epic IDs, credentials)
- Lessons are generalized to characteristics, not specific platforms

### 2. After Runs (Two-Tier Logging)
- **Quick Reference**: Appends one-liner to `quick-reference.log` (agents read this)
- **Detailed Insights**: Creates markdown file with full context (humans review this)
- Updates `INDEX.md` with new entries

### 3. Next Runs
- `lead-architect` reads `quick-reference.log` on startup (fast, comprehensive)
- Applies relevant lessons to current run
- Avoids mistakes other team members already solved

### 4. Version Updates
- Maintainer reviews detailed markdown files
- Applies best learnings to agent definitions
- Releases improved version for all users

### 5. Everyone Benefits
- Your team's experience improves the swarm
- Other teams' experiences improve your runs
- Collective intelligence grows continuously

## Two-Tier Structure

### Tier 1: Quick Reference (For Agents)

**File**: `quick-reference.log`

```
REST-API|Rate-Limiting|Check 429 status, use Retry-After header, exponential backoff 60→120→240s
PowerShell|Module-Check|Get-Module -ListAvailable before Import-Module, check version
Database|SQL-Collation|Check SERVERPROPERTY('Collation') before install, must match
```

- **Purpose**: Fast scanning by agents on startup
- **Format**: Category|Subcategory|One-liner solution
- **Usage**: lead-architect reads entire file in <1 second
- **Maintenance**: Append-only, no git conflicts

### Tier 2: Detailed Insights (For Humans)

**Structure**:
```
insights/
├── quick-reference.log          # Agents read this (fast)
├── INDEX.md                      # Human navigation
├── README.md                     # This file
├── platform-insights/            # Platform-specific discoveries
│   ├── rest-api-rate-limiting.md
│   ├── powershell-module-check.md
│   └── database-collation.md
├── pattern-insights/             # Pattern adaptations
│   ├── idempotency-strategies.md
│   ├── error-recovery.md
│   └── testing-approaches.md
└── operational-insights/         # Failures, prerequisites
    ├── prerequisite-pitfalls.md
    ├── hung-installer-detection.md
    └── recovery-strategies.md
```

- **Purpose**: Deep context for maintainer review
- **Format**: Structured markdown with examples, metrics, code
- **Usage**: You review when curating agent improvements
- **Maintenance**: One file per significant lesson

## Quick Reference Format

**File**: `quick-reference.log`

```
CATEGORY|SUBCATEGORY|LESSON (one-liner with solution)
```

**Example**:
```
Platform|REST-API-Rate-Limiting|Check 429 status, use Retry-After header, exponential backoff 60→120→240s
Pattern|Idempotency-Check|Always check current state before create/update, avoid duplicate operations
Operational|Hung-Installer|Monitor log filesize every 10s, kill if no growth for 60s
```

**Categories**:
- `Platform` - Platform-specific discoveries
- `Pattern` - Pattern adaptations and improvements
- `Operational` - Failures, prerequisites, environment handling

## Detailed Insight Format

Each markdown file follows this structure:

```markdown
# Insight: [Title]

**Date**: YYYY-MM-DD  
**Category**: [Platform|Pattern|Operational]  
**Subcategory**: [Specific type]  
**Applies To**: [Characteristics, not platform names]  
**Applied To Agents**: [List of agents]  
**Severity**: [Low|Medium|High]  

## The Problem

[What went wrong or what was discovered]

## What We Learned

[Clear description of the lesson]

## The Solution

[Specific guidance with code examples if applicable]

```python
# Example code pattern
```

## Impact

**Before**: [metric]  
**After**: [metric]  
**Time Saved**: [if applicable]  

## Applies To

[List of characteristics where this applies]
- Cloud APIs (Azure, AWS, GCP)
- Custom REST endpoints
- etc.
```

## Privacy & Sanitization

**Always Remove**:
- ❌ Customer names or organizations
- ❌ IP addresses or hostnames
- ❌ Jira epic IDs or project keys
- ❌ Specific URLs (except public documentation)
- ❌ Credentials, tokens, or secrets
- ❌ Internal tool names or processes

**Always Keep**:
- ✅ Characteristics (REST API, PowerShell, CLI)
- ✅ Generic patterns (retry logic, validation)
- ✅ Technical lessons (timeout values, best practices)
- ✅ Success/failure metrics (percentages, improvements)

## How Agents Write Insights

### For learning-evolution-specialist Agent

**Every Lesson** (always do this):
1. Capture lesson during run with full context
2. Sanitize (strip personal info: IPs, customer names, epic IDs)
3. Categorize (Platform/Pattern/Operational + subcategory)
4. **Append one-liner** to `quick-reference.log`:
   ```
   Category|Subcategory|One-line solution
   ```

**Significant Lessons** (judgment call):
5. Create detailed markdown file in appropriate directory
6. Include: problem, solution, code examples, metrics
7. Update `INDEX.md` with new entry

### For lead-architect Agent

**On Startup** (Phase 0 - before asking questions):
1. Read `quick-reference.log` (entire file, fast scan)
2. Load relevant lessons into context
3. Apply lessons during orchestration
4. Avoid mistakes already solved by team

### For Maintainers

**Periodic Review** (weekly/monthly):
1. Review new detailed markdown files
2. Validate sanitization (no personal info leaked)
3. Identify high-value lessons
4. Update agent definitions permanently
5. Update version and release notes
6. Push new version to repository

**Result**: Everyone's runs get smarter automatically

## Examples

### Good Quick Reference Entry ✅

```
Platform|REST-API-Rate-Limiting|Check 429 status, use Retry-After header, exponential backoff 60→120→240s
```

**Why it's good**:
- ✅ Generic subcategory (not specific platform name)
- ✅ Actionable one-liner solution
- ✅ Concise but complete

### Good Detailed Insight ✅

**File**: `platform-insights/rest-api-rate-limiting.md`

```markdown
# Insight: REST API Rate Limiting Detection

**Date**: 2024-05-28  
**Category**: Platform  
**Subcategory**: REST-API-Rate-Limiting  
**Applies To**: REST APIs with rate limiting (429 responses)  
**Applied To Agents**: module-worker, jira-ingestion-specialist  
**Severity**: Medium  

## The Problem

Module tests failed 5% of the time during parallel execution against REST APIs. 
HTTP 429 (Too Many Requests) responses were not handled, causing test failures.

## What We Learned

APIs provide retry guidance via Retry-After header. Respecting this header 
eliminates rate limit failures.

## The Solution

1. Check for HTTP 429 status code
2. Read `Retry-After` header (seconds)
3. If header missing, default to 60s
4. Use exponential backoff: 60s → 120s → 240s

```python
if response.status_code == 429:
    retry_after = int(response.headers.get('Retry-After', 60))
    time.sleep(retry_after)
```

## Impact

**Before**: 95% success rate  
**After**: 100% success rate  
**Time Saved**: ~5 min per run (avoiding retries)  

## Applies To

- Cloud APIs (Azure, AWS, GCP)
- Third-party APIs (Jira, ServiceNow, GitHub)
- Any REST endpoint with throttling
```

**Why it's good**:
- ✅ No customer names, IPs, epic IDs
- ✅ Generic characteristics
- ✅ Code examples
- ✅ Metrics showing impact

### Bad Quick Reference Entry ❌

```
Platform|SCVMM-Contoso|Customer needs SQL Server 2019 at 192.168.50.10 for EPIC-2345
```

**Problems**:
- ❌ Customer name (Contoso)
- ❌ IP address (192.168.50.10)
- ❌ Epic ID (EPIC-2345)
- ❌ Not generic or reusable

### Bad Detailed Insight ❌

```markdown
# Insight: SCVMM Installation for Contoso Corp

**Customer**: Contoso Corp
**Environment**: 192.168.50.10
**Epic**: EPIC-2345

SCVMM installation failed for this customer...
```

**Problems**:
- ❌ Contains personal/customer information
- ❌ Not sanitized
- ❌ Not reusable for other teams

## Version History

- **v1.0.0** (2024-05-28): Initial structure created
- Future versions will include insights from production runs

## Questions?

See main repository README or open a GitHub discussion.

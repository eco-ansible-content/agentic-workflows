---
name: ansible-epic-analysis
description: Analyze a Jira Epic for action/info module pairs, find missing pairs in sibling Epics, and check API feasibility. Works on any platform — Windows, cloud, network, SaaS.
---

# Ansible Epic Analysis

Performs a read-only pre-build analysis of a Jira Epic (or ANSTRAT). Identifies all requested modules, maps action+info pairs, finds missing counterparts in sibling Epics, and checks whether the platform API supports the missing operations. Platform-agnostic — works for any Ansible collection regardless of target platform.

## Usage

```
/ansible-epic-analysis EPIC-XXX
/ansible-epic-analysis ANSTRAT-XXX
```

The argument is a Jira ticket key — an Epic, ANSTRAT, or even a single Task (which resolves to its parent Epic).

## When to Use

- Before starting a collection build — to understand scope and gaps
- For gap analysis — to find missing info or action module tickets
- For planning — to verify API feasibility before creating tickets

## Execution Steps

Follow these steps exactly when this skill is invoked. Do NOT ask the user any clarifying questions about ticket content — research autonomously.

### Step 0: Detect Jira CLI Binary

Before running any Jira commands, resolve which CLI binary to use. Check in this order and use the first one found:

1. `jira-rh` — preferred Red Hat CLI
2. `which jira` — standard `jira` on PATH
3. Common binary directories — scan well-known locations for a `jira` executable

```bash
if command -v jira-rh &>/dev/null; then
  JIRA_CMD="jira-rh"
elif JIRA_PATH=$(which jira 2>/dev/null) && [ -x "$JIRA_PATH" ]; then
  JIRA_CMD="$JIRA_PATH"
else
  JIRA_CMD=""
  for dir in /usr/bin /usr/local/bin /usr/local/sbin /home/bin "$HOME/bin" "$HOME/.local/bin"; do
    if [ -x "$dir/jira" ]; then
      JIRA_CMD="$dir/jira"
      break
    fi
  done
  if [ -z "$JIRA_CMD" ]; then
    echo "ERROR: No Jira CLI found (tried jira-rh, jira, common bin paths). Install one and retry."
    exit 1
  fi
fi
echo "Using Jira CLI: $JIRA_CMD"
```

Use `$JIRA_CMD` in place of `jira-rh` for every command in this skill.

### Step 1: Parse Input and Detect Ticket Type

Extract the Jira ticket key from the user's message (pattern: `[A-Z]+-\d+`).

```bash
$JIRA_CMD issue <TICKET-KEY>
```

**DO NOT use Atlassian MCP** — use `$JIRA_CMD` CLI only.

Read the `Type:` field from the output and branch:

- **Epic** → this is the target Epic. Proceed to Step 2.
- **ANSTRAT or Initiative** → this IS the parent scope. Parse `Child Issues:` / `Child Epics:` from the output to get all Epic keys. Analyze ALL Epics combined. Skip Step 5 (sibling search) since all Epics are already in scope.
- **Task or Story** → look for `Parent:` or `Epic Link:` in the output to find the parent Epic key. Run `$JIRA_CMD issue <PARENT-EPIC-KEY>` and use that as the target Epic.

### Step 2: Read the Epic and All Child Tickets

Fetch the Epic details:

```bash
$JIRA_CMD issue <EPIC-KEY>
```

From the output, parse the `Subtasks:` or `Issues in Epic:` section to collect all child ticket keys.

For each child ticket:

```bash
$JIRA_CMD issue <CHILD-KEY>
```

Collect from each ticket: key, summary, description, status.

If the input was an ANSTRAT, repeat this for every Epic under it.

### Step 3: Summarize Epic Goals

From the Epic description and the aggregate of all child tickets, write a concise summary (2-3 sentences) covering:
- What platform/system is being automated
- What the collection aims to accomplish
- The scope (number of modules, resource types)

### Step 4: Classify Tickets into Action/Info Pairs

For each child ticket, determine whether it describes an **action module** or an **info module**, and extract its **base name** (the resource it manages).

#### Detection logic (apply in order):

**1. Module name suffix** (strongest signal):
- If the ticket summary or description mentions a module name ending in `_info` → classify as **INFO**
- If it mentions a module name without `_info` → classify as **ACTION**

**2. Keyword classification** (from ticket summary):

ACTION keywords (create/modify/delete a resource):
- manage, create, update, delete, remove, add, modify, configure, set, enable, disable, deploy, provision, assign

INFO keywords (read/list/query a resource):
- info, information, get, list, query, retrieve, fetch, show, read, discover, facts, gather

**3. Base name extraction**:
- Extract the resource name from the ticket summary (e.g., "Create host management module" → `<prefix>_host`)
- Normalize to `snake_case`
- Strip `_info` suffix if present
- Group tickets by base name

**4. Edge cases**:
- Ambiguous tickets → flag as "Unclassified" in the output
- Utility/helper tickets (not resource management) → mark as "Standalone" with no expected pair
- A ticket describing both action AND info → classify as ACTION (action module subsumes some read operations)

After classification, build a pairs table: for each base name, note whether the action ticket and info ticket exist.

### Step 5: Search Sibling Epics for Missing Pairs

**Skip this step if the input was an ANSTRAT** (all Epics are already in scope).

For each incomplete pair (missing action or info ticket):

1. From the target Epic's `$JIRA_CMD` output, look for a parent reference. Check these fields in order:
   - `Parent:`
   - `Epic Link:`
   - `Initiative:`
   - `Parent Issue:`

2. If a parent key is found:
   ```bash
   $JIRA_CMD issue <PARENT-KEY>
   ```
   Parse `Child Issues:` / `Child Epics:` to get all sibling Epic keys (excluding the target Epic).

3. For each sibling Epic, first scan its summary for relevance (same platform/collection). Skip clearly unrelated Epics to avoid excessive API calls.

4. For relevant sibling Epics:
   ```bash
   $JIRA_CMD issue <SIBLING-EPIC-KEY>
   ```
   Parse its child tickets. For each child ticket:
   ```bash
   $JIRA_CMD issue <TICKET-KEY>
   ```
   Apply the same pair-detection logic from Step 4. Check if any ticket matches a missing base name.

5. If no parent reference is found in the Epic output, skip this step and report:
   > Could not determine parent ANSTRAT/Initiative for this Epic. Sibling Epic search was skipped.

### Step 6: API Feasibility Check

For each pair that is STILL incomplete after the sibling search, research whether the platform API supports the missing operation.

**Determine what is missing**:
- Missing INFO module → search for read/list/query/get API support
- Missing ACTION module → search for create/update/delete API support

**Detect the platform type** from the Epic description, ticket summaries, and module name prefixes. Use signals like:

| Signal | Platform type |
|--------|--------------|
| Module prefix `scvmm_`, `ad_`, `win_`, `exchange_` or mentions PowerShell/cmdlets | Windows/PowerShell |
| Module prefix `ec2_`, `s3_`, `aws_`, `lambda_` or mentions AWS/boto3 | AWS SDK |
| Module prefix `azure_rm_`, `azure_` or mentions Azure | Azure SDK/REST |
| Module prefix `gcp_`, `gce_` or mentions Google Cloud | GCP REST/SDK |
| Module prefix `ios_`, `nxos_`, `eos_`, `junos_`, `vyos_` or mentions network devices | Network CLI |
| Module prefix `meraki_`, `aci_`, `mso_`, `nsx_` or mentions network API | Network REST API |
| Module prefix `vmware_`, `vcenter_` or mentions vSphere/ESXi | VMware SDK (pyVmomi/REST) |
| Module prefix `k8s_`, `helm_` or mentions Kubernetes | Kubernetes API |
| Module prefix `splunk_`, `snow_`, `pagerduty_`, `datadog_` or mentions SaaS | SaaS REST API |
| No clear signal | Default to REST API search |

**Search strategy by platform type:**

For **Windows/PowerShell** platforms:
```
WebSearch("<platform-name> <ResourceName> PowerShell cmdlets site:learn.microsoft.com")
```
Look for `Get-*` cmdlets (info) or `New-*/Set-*/Remove-*` cmdlets (action).

For **AWS** (boto3 SDK):
```
WebSearch("boto3 <service> <resource-type> methods site:boto3.amazonaws.com")
```
Look for `describe_*`/`list_*` methods (info) or `create_*`/`update_*`/`delete_*` methods (action).

For **Azure** (SDK/REST):
```
WebSearch("azure <resource-type> REST API reference site:learn.microsoft.com")
```
Look for `GET` endpoints (info) or `PUT`/`PATCH`/`DELETE` endpoints (action).

For **GCP** (REST/SDK):
```
WebSearch("google cloud <resource-type> API reference site:cloud.google.com")
```
Look for `get`/`list` methods (info) or `insert`/`update`/`delete` methods (action).

For **Network CLI** platforms:
```
WebSearch("<platform-name> <resource-type> CLI command reference")
```
Look for `show`/`display` commands (info) or `configure`/`set`/`no` commands (action).

For **Network REST API** platforms:
```
WebSearch("<platform-name> <resource-type> API reference")
```
Look for `GET` endpoints (info) or `POST`/`PUT`/`DELETE` endpoints (action).

For **VMware** (vSphere):
```
WebSearch("vsphere <resource-type> API reference pyVmomi")
```
Look for `vim.<Type>` managed objects and their methods.

For **SaaS/REST** platforms:
```
WebSearch("<platform-name> <resource-type> API reference")
```
Look for `GET` endpoints (info) or `POST`/`PUT`/`PATCH`/`DELETE` endpoints (action).

For **Kubernetes**:
```
WebSearch("kubernetes <resource-type> API reference site:kubernetes.io")
```
Look for `get`/`list` verbs (info) or `create`/`update`/`patch`/`delete` verbs (action).

**Report one of**:
- `Supported` — name the specific cmdlet, endpoint, or SDK method found (e.g., `Get-SCVMHost`, `ec2:DescribeInstances`, `GET /api/v1/namespaces`)
- `Not found` — no matching API operation discovered
- `Inconclusive` — manual verification recommended

### Step 7: Print Output

Print the full analysis to the conversation. Do NOT create files.

Use this format:

```markdown
## Epic Analysis: <EPIC-KEY>

### Goal Summary

<2-3 sentence summary of the Epic's purpose, platform, and scope>

---

### Module Pair Analysis

Total tickets analyzed: <N>
Action modules: <N> | Info modules: <N>
Complete pairs: <N> | Incomplete pairs: <N>

| # | Base Name | Action Module | Info Module | Action Ticket | Info Ticket | API Support | Status |
|---|-----------|---------------|-------------|---------------|-------------|-------------|--------|
| 1 | <prefix>_host | <prefix>_host | <prefix>_host_info | XXX-1234 | XXX-1235 | — | Complete |
| 2 | <prefix>_vm | <prefix>_vm | <prefix>_vm_info | XXX-1236 | — | `<read operation>` | Missing Info (API Available) |
| 3 | <prefix>_net | — | <prefix>_net_info | — | XXX-1238 (in EPIC-999) | `<create operation>` | Missing Action (Found in EPIC-999) |
| 4 | <prefix>_cloud | <prefix>_cloud | — | XXX-1240 | — | Not found | Missing Info (No API) |
| 5 | <prefix>_util | <prefix>_util | — | XXX-1242 | — | — | Standalone |
```

**Status values**:
- `Complete` — both action and info tickets exist in the target Epic
- `Missing Info` / `Missing Action` — counterpart ticket not found anywhere
- `Missing Info (API Available)` / `Missing Action (API Available)` — not found but API supports it
- `Missing Info (No API)` / `Missing Action (No API)` — not found and API doesn't support it
- `Found in <EPIC-XXX>` — counterpart found in a sibling Epic (append to Missing status)
- `Standalone` — utility module, no info counterpart expected

Do NOT print a full sibling Epic table. The sibling search happens behind the scenes — only surface results that matter:
- If a missing pair WAS found in a sibling Epic, note it in the main table's Status column as `Found in <EPIC-XXX>` and in the ticket column as `<TICKET-KEY> (in <EPIC-KEY>)`.
- If nothing was found, do NOT print a "Sibling Epic Search" section at all — just proceed to recommendations.

End with:

```markdown
---

### Recommendations

- <For each incomplete pair: state whether creating the missing module is feasible and name the specific API operations that support it>
  - Cmdlet example: "<prefix>_job action module — feasible. Supported by `Stop-SCJob` and `Restart-SCJob` cmdlets."
  - SDK example: "<prefix>_bucket_info module — feasible. Supported by `s3:ListBuckets` and `s3:GetBucketPolicy`."
  - REST example: "<prefix>_rule action module — feasible. Supported by `POST /api/v2/rules` and `DELETE /api/v2/rules/{id}`."
  - CLI example: "<prefix>_vlan action module — feasible. Supported by `vlan <id>` and `no vlan <id>` configuration commands."
- <If a missing module has no API support: "<prefix>_example action module — not feasible. No create/update/delete API found.">
- <Overall status: "N of M pairs are complete and ready for implementation.">
```

**Recommendations rules**:
- Do NOT ask the user questions or suggest they "consider" anything
- State feasibility as a fact: "feasible" or "not feasible"
- Always name the specific cmdlet/API commands that support the missing module
- Keep each recommendation to one line

## Error Handling

- **No Jira CLI found**: Report the error from Step 0 and stop — do not proceed. Common paths searched: `/usr/bin`, `/usr/local/bin`, `/usr/local/sbin`, `/home/bin`, `~/bin`, `~/.local/bin`.
- **$JIRA_CMD command fails**: Report the error and suggest checking credentials (`jira-rh config` or `$JIRA_CMD config`).
- **No parent found for Epic**: Skip sibling search, report clearly.
- **No child tickets in Epic**: Report "Epic has no child tickets" and stop.
- **ANSTRAT with many Epics (10+)**: Process all but log progress ("Analyzing Epic 3 of 12...").

## Important Rules

- Use `$JIRA_CMD issue <KEY>` for ALL Jira access — **NEVER** use Atlassian MCP
- **Print** output to conversation — do NOT save to files
- Do NOT ask the user clarifying questions about ticket content — research autonomously
- This is a **read-only** analysis — do not modify any files or create artifacts
- Do NOT invoke other agents or skills — execute all steps inline

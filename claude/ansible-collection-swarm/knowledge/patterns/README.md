# Pattern Library

Generic implementation patterns that work across multiple platforms.

## Available Patterns

1. **REST API Pattern** - Azure, AWS, SolarWinds, Jira, ServiceNow, etc.
2. **CLI-Based Pattern** - Cisco, Linux, Windows PowerShell, Juniper, etc.
3. **Config File Pattern** - Kubernetes, Docker, Terraform, etc.
4. **Database Pattern** - SQL Server, PostgreSQL, MongoDB, etc.
5. **SOAP API Pattern** - Legacy enterprise systems

## How to Use

Module Worker reads platform characteristics → Matches to pattern → Adapts implementation

**Example**:
- Platform: "REST API (SWIS)"
- Match: REST API Pattern
- Implement: GET-compare-POST/PUT/DELETE logic

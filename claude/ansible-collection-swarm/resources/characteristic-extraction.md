# Characteristic Extraction Guide

## What to Extract from Epic

1. **Platform name** - What are we managing?
2. **Automation method** - API, CLI, config files?
3. **Module language** - Python, PowerShell, Bash?
4. **Connection type** - winrm, ssh, httpapi, local?
5. **Prerequisites** - What needs to be installed?

## How to Infer Dependencies

**SCVMM** → Needs: SQL Server, Hyper-V  
**Azure modules** → Needs: Subscription, credentials  
**Cisco** → Needs: Test switch or simulator

## Research Process

1. Read Epic thoroughly
2. Search: "How to automate X platform"
3. Find SDK/API documentation
4. Infer dependencies from prerequisites
5. Write natural language description

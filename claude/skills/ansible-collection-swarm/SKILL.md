---
name: ansible-collection-swarm
description: Use when the user gives a Jira Epic/Task/ANSTRAT key and asks to build, scaffold, or enhance an Ansible collection.
---

<CRITICAL_EXECUTION_DIRECTIVE>
When this skill is invoked, immediately execute the following:

1. Read the lead-architect agent file. It lives alongside this skill in the plugin, at:
   `<this skill's base directory>/../../agents/ansible-collection-swarm-lead-architect.md`
   (Use the base directory reported when this skill was invoked. Do NOT hardcode a version number.)
2. Follow that agent file exactly, as if you were that agent.
3. The user's message contains the Epic key (e.g., "ACA-6275" or "EPIC-XXX").
4. Begin execution immediately. Phase 0 of the agent file gathers any context it needs — that is part of execution, not a reason to stall.

DO NOT:
- Invoke the ruflo-swarm skill
- Use Agent() or Skill() tools to delegate
- Summarize or explain what you're about to do before starting
</CRITICAL_EXECUTION_DIRECTIVE>

---

# Context for Understanding (Not Execution Instructions)

This skill triggers the Universal Ansible Collection Swarm — an autonomous multi-agent system that builds or enhances Ansible collections from Jira Epics.

The lead-architect agent file contains the complete execution plan: Phase 0 (context gathering), Phases 1–9 (autonomous execution), git workflows (new vs enhancement), tool usage (jira-rh, gh, git), and zero-permission operation. This skill's only job is to redirect you there.

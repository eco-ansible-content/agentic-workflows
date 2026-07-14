# Python Unit Test Pattern

Mandatory for every new or changed **Python** (`.py`) Ansible module in the Universal Collection Swarm.

PowerShell (`.ps1`) modules do **not** use this pattern — integration tests only.

## Path Layout

```
tests/unit/plugins/modules/test_<module_name>.py
```

Run with:

```bash
ansible-test units --python 3.9
```

## What to Cover

1. Argument / parameter validation failures
2. Happy path (create/update/delete as applicable)
3. Idempotency decision (no change when already desired)
4. Error paths (API/SDK failures surfaced via `fail_json`)

## Rules

- Mock external dependencies (HTTP, cloud SDKs, subprocess) — never hit live systems in unit tests
- Prefer `unittest.mock` / `pytest` patterns already used in the target collection
- Keep tests focused on module logic, not integration connectivity

## Minimal Example

```python
# tests/unit/plugins/modules/test_example_resource.py
from __future__ import absolute_import, division, print_function

__metaclass__ = type

from unittest.mock import MagicMock, patch

import pytest

from ansible_collections.<namespace>.<name>.plugins.modules import example_resource


class TestExampleResource:
    def test_missing_required_param_fails(self, mocker):
        module = MagicMock()
        module.params = {"name": None, "state": "present"}
        # Assert module fails when required params are missing
        # Adapt to collection's AnsibleModule test helpers if present

    @patch.object(example_resource, "get_client")
    def test_create_when_absent(self, mock_get_client):
        client = MagicMock()
        mock_get_client.return_value = client
        client.get.return_value = None
        client.create.return_value = {"id": "1", "name": "demo"}
        # Assert create is called and changed=True
```

Adapt imports and helpers to match the collection under test (some collections ship `tests/unit/.../conftest.py` or ansible-test fixtures).

## Risk Gate

If mocks would be incomplete or misleading (proprietary SDK, live-only APIs, no mock surface):

1. **STOP** and ask the user with an explicit risk statement
2. Do **not** silently skip unit tests
3. Continue only after the user decides (proceed without / weaken / keep required)

Example prompt:

> Risk: This module depends on live proprietary SDK calls that are difficult to mock. Unit coverage may be incomplete or misleading. Proceed without full unit tests / accept weakened mocks / keep unit tests required?

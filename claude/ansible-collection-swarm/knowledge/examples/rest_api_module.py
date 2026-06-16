#!/usr/bin/python
# Generic REST API module pattern

from ansible.module_utils.basic import AnsibleModule
import requests

def main():
    module = AnsibleModule(
        argument_spec=dict(
            api_url=dict(type='str', required=True),
            resource_id=dict(type='str', required=True),
            state=dict(choices=['present', 'absent'], default='present')
        ),
        supports_check_mode=True
    )
    
    # GET current state
    response = requests.get(f"{module.params['api_url']}/{module.params['resource_id']}")
    exists = response.status_code == 200
    
    # Apply changes
    if module.params['state'] == 'present' and not exists:
        if not module.check_mode:
            requests.post(module.params['api_url'], json={})
        module.exit_json(changed=True)
    elif module.params['state'] == 'absent' and exists:
        if not module.check_mode:
            requests.delete(f"{module.params['api_url']}/{module.params['resource_id']}")
        module.exit_json(changed=True)
    else:
        module.exit_json(changed=False)

if __name__ == '__main__':
    main()

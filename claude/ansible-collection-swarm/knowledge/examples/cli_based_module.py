#!/usr/bin/python
# Generic CLI-based module pattern

from ansible.module_utils.basic import AnsibleModule

def main():
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(type='str', required=True),
            state=dict(choices=['present', 'absent'], default='present')
        ),
        supports_check_mode=True
    )
    
    # Check current state
    result = module.run_command(['show', 'config', module.params['name']])
    exists = result[0] == 0
    
    # Apply changes
    if module.params['state'] == 'present' and not exists:
        if not module.check_mode:
            module.run_command(['configure', module.params['name']])
        module.exit_json(changed=True)
    elif module.params['state'] == 'absent' and exists:
        if not module.check_mode:
            module.run_command(['delete', module.params['name']])
        module.exit_json(changed=True)
    else:
        module.exit_json(changed=False)

if __name__ == '__main__':
    main()

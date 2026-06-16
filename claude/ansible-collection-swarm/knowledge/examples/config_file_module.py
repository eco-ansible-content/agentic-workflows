#!/usr/bin/python
# Generic config file module pattern

from ansible.module_utils.basic import AnsibleModule
import json

def main():
    module = AnsibleModule(
        argument_spec=dict(
            path=dict(type='str', required=True),
            config=dict(type='dict', required=True)
        ),
        supports_check_mode=True
    )
    
    # Read current config
    try:
        with open(module.params['path']) as f:
            current = json.load(f)
    except:
        current = {}
    
    # Compare
    if current != module.params['config']:
        if not module.check_mode:
            with open(module.params['path'], 'w') as f:
                json.dump(module.params['config'], f)
        module.exit_json(changed=True)
    else:
        module.exit_json(changed=False)

if __name__ == '__main__':
    main()

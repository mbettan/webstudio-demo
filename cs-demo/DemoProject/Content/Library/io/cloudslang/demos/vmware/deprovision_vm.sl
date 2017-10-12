#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @result SUCCESS: The machine has been powered off (return_code 0)
#! @result FAILURE: The operation failed (return_code -1)
#!!#
########################################################################################################################

namespace: io.cloudslang.demos.vmware
imports:
  actions: io.cloudslang.vmware.vcenter
  vm: io.cloudslang.vmware.vcenter.vm
flow:
  name: deprovision_vm
  inputs:
    - host
    - user:
        required: false
    - password:
        sensitive: true
    - port:
        default: '443'
    - protocol:
        default: https
    - vm_identifier
    - vm_name
    - step_timeout:
        default: '800'
        required: false
    - datacenter:
        required: false
    - auth_type:
        default: basic
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8443'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
  workflow:
    - power_off_vm:
        do:
          actions.power_off_vm:
            - host
            - user
            - password
            - port
            - protocol
            - step_timeout
            - vm_identifier
            - vm_name
            - datacenter
            - wait_guest: 'false'
            - auth_type
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_code
          - failure_message
        navigate:
          - SUCCESS: delete_vm
          - FAILURE: on_failure
    - delete_vm:
        do:
          vm.delete_vm:
            - host
            - user
            - password
            - port
            - protocol
            - vm_identifier
            - vm_name
            - async: 'false'
            - task_time_out: '${step_timeout}'
            - auth_type
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_code
          - failure_message: "${return_result if return_code=='-1' else ''}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - return_code
    - return_result: "${\"Successfully deleted virtual machine \" + vm_name if return_code=='0' else \"Failed to delete virtual machine \" + vm_name+\":\"+failure_message}"
    - failure_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      power_off_vm:
        x: 100
        y: 100
      delete_vm:
        x: 278
        y: 109
        navigate:
          aa374e8c-5395-949b-2b15-33f6f9cdda30:
            targetId: 6d06c9c4-4ae9-2fcd-1502-6cd7802fd9e0
            port: SUCCESS
    results:
      SUCCESS:
        6d06c9c4-4ae9-2fcd-1502-6cd7802fd9e0:
          x: 486
          y: 110

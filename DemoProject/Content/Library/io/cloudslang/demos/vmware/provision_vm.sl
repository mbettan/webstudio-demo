#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @result SUCCESS: The operation completed successfully. (return_code 0)
#! @result FAILURE: An exception occured. (return_code -1)
#!!#
########################################################################################################################

namespace: io.cloudslang.demos.vmware
imports:
  subflows: io.cloudslang.vmware.vcenter.util
  actions: io.cloudslang.vmware.vcenter
  vm: io.cloudslang.vmware.vcenter.vm
flow:
  name: provision_vm
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
    - step_timeout:
        default: '800'
        required: false
    - vm_source_identifier
    - vm_source
    - datacenter
    - vm_name
    - vm_folder
    - resource_pool:
        required: false
    - datastore:
        required: false
    - host_system:
        required: false
    - cluster_name:
        required: false
    - description:
        required: false
    - thin_provision:
        required: false
    - customization_template_name:
        required: false
    - customization_spec_xml:
        required: false
    - connection_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - vm_cpu_count:
        default: '2'
    - vm_memory_size:
        default: '1024'
    - auth_type:
        default: basic
        private: false
        required: false
        sensitive: false
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
    - create_vm_folder_if_inexistent:
        do:
          vm.create_vm_folder_if_inexistent:
            - host
            - user
            - password
            - port
            - protocol
            - datacenter
            - vm_folder
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
          - return_result
          - failure_message: "${return_result if return_code=='-1' else ''}"
        navigate:
          - SUCCESS: create_clone
          - FAILURE: on_failure
    - create_clone:
        do:
          vm.clone_vm:
            - host
            - user
            - password
            - port
            - protocol
            - async: 'false'
            - task_time_out: '${step_timeout}'
            - vm_source_identifier
            - vm_source
            - datacenter
            - vm_name: '${vm_name}'
            - vm_folder
            - resource_pool
            - datastore
            - host_system
            - cluster_name
            - description
            - mark_as_template: 'false'
            - thin_provision
            - customization_template_name
            - customization_spec_xml
            - connection_timeout
            - socket_timeout
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
          - return_result
          - failure_message: "${return_result if return_code=='-1' else ''}"
          - vm_id
          - inventory_path
        navigate:
          - SUCCESS: set_cpu
          - FAILURE: on_failure
    - set_cpu:
        do:
          actions.set_vm_cpu:
            - host
            - user
            - password
            - port
            - protocol
            - vm_identifier: vmId
            - vm_name: '${vm_id}'
            - async: 'false'
            - step_timeout
            - datacenter
            - cpu_provision_type: provision
            - vm_cpu_count
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
          - SUCCESS: set_memory
          - FAILURE: on_failure
    - set_memory:
        do:
          actions.set_vm_memory:
            - host
            - user
            - password
            - port
            - protocol
            - vm_identifier: vmId
            - vm_name: '${vm_id}'
            - vm_memory_size
            - async: 'false'
            - step_timeout
            - datacenter
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
          - SUCCESS: power_on_vm
          - FAILURE: on_failure
    - power_on_vm:
        do:
          actions.power_on_vm:
            - host
            - user
            - password
            - port
            - protocol
            - step_timeout
            - vm_identifier: vmId
            - vm_name: '${vm_id}'
            - datacenter
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
          - SUCCESS: get_vm_info
          - FAILURE: on_failure
    - get_vm_info:
        do:
          subflows.wait_for_vm_info:
            - host
            - user
            - password
            - port
            - protocol
            - datacenter
            - vm_identifier: vmId
            - vm_name: '${vm_id}'
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
          - vm_id
          - ip
          - fqdn
          - guest_full_name
          - inventory_path
          - return_result
          - return_code
          - failure_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - vm_id
    - ip
    - fqdn
    - inventory_path
    - guest_full_name
    - return_code
    - return_result: "${\"Successfully created virtual machine \" + vm_name if return_code=='0' else \"Failed to create virtual machine \" + vm_name+\":\"+failure_message}"
    - failure_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_vm_folder_if_inexistent:
        x: 36
        y: 70
      create_clone:
        x: 212
        y: 74
      set_cpu:
        x: 387
        y: 74
      set_memory:
        x: 564
        y: 73
      power_on_vm:
        x: 738
        y: 71
      get_vm_info:
        x: 906
        y: 72
        navigate:
          29927aa3-39d2-e0ec-8f8d-aafa5909419a:
            targetId: 6538af5a-65cc-e60c-8ff2-29fb201cbc0c
            port: SUCCESS
    results:
      SUCCESS:
        6538af5a-65cc-e60c-8ff2-29fb201cbc0c:
          x: 1102
          y: 80

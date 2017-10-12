#!!
#! @description: Computes a JSON body with key and reset values for the Unseal API
#!!#
namespace: io.cloudslang.demos.vault
flow:
  name: compute_unseal_body
  inputs:
    - unseal_key:
        required: false
    - unseal_reset:
        required: false
    - computed_json:
        default: '{"reset":false}'
        private: true
        required: true
  workflow:
    - check_key_if_empty:
        do:
          io.cloudslang.demos.vault.string_equals:
            - first_string: '${unseal_key}'
            - second_string: ''
            - ignore_case: 'true'
        navigate:
          - FAILURE: add_key_value
          - SUCCESS: check_reset_if_empty
          - NONE: check_reset_if_empty
    - check_reset_if_empty:
        do:
          io.cloudslang.demos.vault.string_equals:
            - first_string: '${unseal_reset}'
            - second_string: ''
            - ignore_case: 'true'
        navigate:
          - FAILURE: add_reset_value
          - SUCCESS: SUCCESS
          - NONE: SUCCESS
    - add_key_value:
        do:
          io.cloudslang.base.json.add_value:
            - json_input: '{"key":"","reset":false}'
            - json_path: key
            - value: '${unseal_key}'
        publish:
          - computed_json: '${return_result}'
          - return_code: '${return_code}'
          - error_message: '${error_message}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_reset_if_empty
    - add_reset_value:
        do:
          io.cloudslang.base.json.add_value:
            - json_input: '${computed_json}'
            - json_path: reset
            - value: '${unseal_reset}'
        publish:
          - computed_json: '${return_result}'
          - return_code: '${return_code}'
          - error_message: '${error_message}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - return_result: '${computed_json}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      check_key_if_empty:
        x: 122
        y: 81
      check_reset_if_empty:
        x: 484
        y: 85
        navigate:
          dab05568-5768-52bf-8e55-0aabab7db559:
            targetId: bcf12c06-6f3a-5afd-4dbd-cc549bfbaac7
            port: SUCCESS
          5b50b383-da9f-614f-ca11-a557dae0c232:
            targetId: bcf12c06-6f3a-5afd-4dbd-cc549bfbaac7
            port: NONE
      add_key_value:
        x: 259
        y: 302
      add_reset_value:
        x: 639
        y: 301
        navigate:
          86465dbc-b8c7-ac9f-c85a-f124d7563647:
            targetId: bcf12c06-6f3a-5afd-4dbd-cc549bfbaac7
            port: SUCCESS
    results:
      SUCCESS:
        bcf12c06-6f3a-5afd-4dbd-cc549bfbaac7:
          x: 832
          y: 115

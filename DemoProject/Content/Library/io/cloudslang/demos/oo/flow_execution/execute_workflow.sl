namespace: io.cloudslang.demos.oo.flow_execution
flow:
  name: execute_workflow
  inputs:
    - host:
        default: myd-vm00301.hpeswlab.net
        private: true
    - protocol:
        default: https
        private: true
    - port:
        default: '9445'
        private: true
    - username:
        default: admin
        private: true
    - password:
        default: cloud
        private: true
    - flow_uuid
    - flow_details:
        default: ' '
        private: true
  workflow:
    - trigger_flow:
        do:
          io.cloudslang.demos.oo.flow_execution.utils.http_client_post:
            - url: "${protocol+'://'+host+':'+port+'/oo/rest/latest/executions'}"
            - username: '${username}'
            - password: '${password}'
            - body: "${'{\"flowUuid\":\"'+flow_uuid+'\",\"inputs\":{},\"logLevel\":\"STANDARD\"}'}"
            - content_type: application/json
            - connections_max_total: '100'
        publish:
          - run_id: '${return_result}'
          - error_message: '${error_message}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_run_details
    - get_run_details:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${protocol+'://'+host+':'+port+'/oo/rest/executions/'+run_id+'/execution-log'}"
            - username: '${username}'
            - password: '${password}'
            - content_type: application/json
            - connections_max_total: '100'
            - connections_max_per_root: '100'
            - connectionsMaxTotal: '100'
            - connectionsMaxPerRoot: '100'
        publish:
          - flow_details: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: extract_status
    - check_flow_result_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: "${flow_status+' - '+flow_result_status}"
            - second_string: '["Completed"] - ["resolved"]'
            - ignore_case: 'true'
        publish:
          - run_status: '${first_string}'
        navigate:
          - FAILURE: OTHER
          - SUCCESS: SUCCESS
    - check_flow_if_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${flow_status}'
            - second_string: '["RUNNING"]'
            - ignore_case: 'true'
        navigate:
          - FAILURE: extract_result_status
          - SUCCESS: wait_for_flow_to_complete
    - wait_for_flow_to_complete:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '5'
        navigate:
          - FAILURE: get_run_details
          - SUCCESS: get_run_details
    - extract_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flow_details}'
            - json_path: '*.status'
        publish:
          - flow_status: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_flow_if_running
    - extract_result_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flow_details}'
            - json_path: '*.resultStatusType'
        publish:
          - flow_result_status: '${return_result}'
          - flow_details: '${json_object}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_flow_result_status
  outputs:
    - run_status: '${flow_status}'
    - run_details_output: '${flow_details}'
    - triggered_flow: '${flow_uuid}'
  results:
    - FAILURE
    - SUCCESS
    - OTHER
extensions:
  graph:
    steps:
      trigger_flow:
        x: 60
        y: 70
      get_run_details:
        x: 252
        y: 73
      check_flow_result_status:
        x: 947
        y: 230
        navigate:
          47f831f4-1dae-82e6-38bd-7daeb930dcb5:
            targetId: b9fccd15-1abe-e1ce-158f-1f92072192c4
            port: SUCCESS
          e7673467-a6aa-18f1-0338-c89cd1b6e516:
            targetId: 2a05409d-3140-0407-24f1-56bf6912f0eb
            port: FAILURE
      check_flow_if_running:
        x: 501
        y: 219
      wait_for_flow_to_complete:
        x: 257
        y: 250
      extract_status:
        x: 467
        y: 69
      extract_result_status:
        x: 681
        y: 249
    results:
      SUCCESS:
        b9fccd15-1abe-e1ce-158f-1f92072192c4:
          x: 1044
          y: 93
      OTHER:
        2a05409d-3140-0407-24f1-56bf6912f0eb:
          x: 1049
          y: 359

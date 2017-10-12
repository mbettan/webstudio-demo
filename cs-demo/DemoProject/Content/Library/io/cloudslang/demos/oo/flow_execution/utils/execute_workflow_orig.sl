namespace: io.cloudslang.demos.oo.flow_execution.utils
flow:
  name: execute_workflow_orig
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
    - flowUuid: d012e1c3-704f-426f-a380-b2425a166d39
    - flowDetails:
        default: ' '
        private: true
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${protocol+'://'+host+':'+port+'/oo/rest/users/me'}"
            - username: '${username}'
            - password: '${password}'
        publish:
          - response_headers: '${response_headers}'
          - return_result: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: trigger_flow
    - trigger_flow:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${protocol+'://'+host+':'+port+'/oo/rest/latest/executions'}"
            - username: '${username}'
            - body: "${'{\"flowUuid\":\"'+flowUuid+'\",\"inputs\":{},\"logLevel\":\"STANDARD\"}'}"
            - password: '${password}'
            - headers: '${response_headers}'
            - content_type: application/json
            - connections_max_total: '100'
            - connections_max_per_root: '100'
            - connectionsMaxTotal: '100'
            - connectionsMaxPerRoot: '100'
        publish:
          - response_headers: '${response_headers}'
          - runId: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_flow_details
    - get_flow_details:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${protocol+'://'+host+':'+port+'/oo/rest/executions/'+runId+'/execution-log'}"
            - username: '${username}'
            - password: '${password}'
            - content_type: application/json
            - headers: '${response_headers}'
            - connections_max_total: '100'
            - connections_max_per_root: '100'
            - connectionsMaxTotal: '100'
            - connectionsMaxPerRoot: '100'
        publish:
          - flowDetails: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: extract_status
    - check_flow_result_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: "${flowStatus+' - '+flowResultStatus}"
            - second_string: '["Completed"] - ["resolved"]'
            - ignore_case: 'true'
        publish:
          - return_result: '${first_string}'
        navigate:
          - FAILURE: OTHER
          - SUCCESS: SUCCESS
    - check_flow_if_running:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${flowStatus}'
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
          - FAILURE: get_flow_details
          - SUCCESS: get_flow_details
    - extract_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flowDetails}'
            - json_path: '*.status'
        publish:
          - flowStatus: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_flow_if_running
    - extract_result_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${flowDetails}'
            - json_path: '*.resultStatusType'
        publish:
          - flowResultStatus: '${return_result}'
          - flowDetails: '${json_object}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_flow_result_status
  outputs:
    - return_result: '${return_result}'
    - flow_details: '${flowDetails}'
  results:
    - FAILURE
    - SUCCESS
    - OTHER
extensions:
  graph:
    steps:
      trigger_flow:
        x: 68
        y: 68
      get_flow_details:
        x: 245
        y: 67
      check_flow_result_status:
        x: 686
        y: 400
        navigate:
          47f831f4-1dae-82e6-38bd-7daeb930dcb5:
            targetId: b9fccd15-1abe-e1ce-158f-1f92072192c4
            port: SUCCESS
          e7673467-a6aa-18f1-0338-c89cd1b6e516:
            targetId: 2a05409d-3140-0407-24f1-56bf6912f0eb
            port: FAILURE
      check_flow_if_running:
        x: 501
        y: 225
      wait_for_flow_to_complete:
        x: 248
        y: 254
      extract_status:
        x: 455
        y: 68
      extract_result_status:
        x: 460
        y: 418
      http_client_get:
        x: 77
        y: 256
    results:
      SUCCESS:
        b9fccd15-1abe-e1ce-158f-1f92072192c4:
          x: 798
          y: 413
      OTHER:
        2a05409d-3140-0407-24f1-56bf6912f0eb:
          x: 660
          y: 242

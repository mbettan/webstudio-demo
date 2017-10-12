namespace: io.cloudslang.demos.vault
flow:
  name: get_json_key_value_pair
  workflow:
    - get_keys_from_json:
        do:
          io.cloudslang.base.json.get_keys:
            - json_input: '{"sealed":true,"t":3,"n":5,"progress":1,"version":"Vault v0.6.1"}'
            - json_path: ''
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - error_message: '${error_message}'
          - return_result_as_list: "${''.join( c for c in return_result if  c not in '\"[] ' )}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_value_for_key
    - get_value_for_key:
        loop:
          for: i in return_result_as_list
          do:
            io.cloudslang.base.json.json_path_query:
              - json_object: '{"sealed":true,"t":3,"n":5,"progress":1,"version":"Vault v0.6.1"}'
              - json_path: "${'.'+i}"
          break:
            - FAILURE
          publish:
            - return_result: "${''.join( c for c in return_result if  c not in '\"[]' )}"
            - return_code: '${return_code}'
            - exception: '${exception}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_keys_from_json:
        x: 91
        y: 74
      get_value_for_key:
        x: 349
        y: 71
        navigate:
          c199ad42-95b8-0942-4d1b-76c5595f6512:
            targetId: 6a5939f7-bb11-dbfe-21c8-60aee4725414
            port: SUCCESS
    results:
      SUCCESS:
        6a5939f7-bb11-dbfe-21c8-60aee4725414:
          x: 632
          y: 73

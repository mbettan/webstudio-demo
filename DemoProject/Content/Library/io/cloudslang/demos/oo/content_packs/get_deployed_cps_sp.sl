########################################################################################################################
#!!
#! @input custom_filter: string based on which cp filtering is performed
#!!#
########################################################################################################################

namespace: io.cloudslang.demos.oo.content_packs

flow:
  name: get_deployed_cps_sp
  inputs:
    - host: localhost
    - port: '9445'
    - protocol: https
    - username: admin
    - password:
        sensitive: true
    - custom_filter
  workflow:
    - get_deployed_content_packs:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${protocol + '://' + host + ':' + port + '/oo/rest/v1/content-packs'}"
            - username: '${username}'
            - password: '${password}'
        publish:
          - return_result
          - return_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: filter_content_packs
    - filter_content_packs:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: '*.name'
            - custom_filter: '${custom_filter}'
        publish:
          - cp_names: '${return_result}'
          - cp_filtered_names: '${",".join(filter(lambda x: True if (x.find(custom_filter) >= 0) else False, return_result.split(",")))}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - cp_filtered_names: '${cp_filtered_names}'
    - cp_names: '${cp_names}'
    - cp_raw_list: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_deployed_content_packs:
        x: 71
        y: 108
      filter_content_packs:
        x: 282
        y: 106
        navigate:
          b89cb0a2-afc3-d7eb-580b-1e46f45d8021:
            targetId: 6586e94a-853e-e723-2c6d-ff75fc5f3ef1
            port: SUCCESS
    results:
      SUCCESS:
        6586e94a-853e-e723-2c6d-ff75fc5f3ef1:
          x: 494
          y: 111

########################################################################################################################
#!!
#! @input hostname: HPE OO hostname FQDN, IPv4 or IPv6
#! @input port: HPE OO port
#! @input username: HPE OO username
#! @input password: HPE OO pssword
#!!#
########################################################################################################################
namespace: io.cloudslang.demos.oo.content_packs
flow:
  name: get_deployed_cps
  inputs:
    - hostname
    - port
    - auth_type:
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
    - keystore:
        default: "${get_sp('io.cloudslang.base.http.keystore')}"
        required: false
    - keystore_password:
        default: "${get_sp('io.cloudslang.base.http.keystore_password')}"
        required: false
        sensitive: true
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
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_deployed_content_packs:
        x: 71
        y: 108
        navigate:
          73166729-c1c6-b3d0-88de-0371fc3efbf6:
            targetId: 6586e94a-853e-e723-2c6d-ff75fc5f3ef1
            port: SUCCESS
    results:
      SUCCESS:
        6586e94a-853e-e723-2c6d-ff75fc5f3ef1:
          x: 494
          y: 111

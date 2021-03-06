#!!
#! @input hostname: Vault FQDN
#! @input port: Vault Port
#! @input protocol: Vault Protocol
#! @input x_vault_token: Vault Token
#!!#
namespace: io.cloudslang.demos.vault
flow:
  name: seal_status
  inputs:
    - hostname
    - port
    - protocol
    - x_vault_token:
        sensitive: true
    - content_type:
        default: application/json
        private: true
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
    - trust_all_root:
        required: false
    - x_509_hostname_verifier:
        required: false
  workflow:
    - interogate_vault_server:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${protocol + '://' + hostname + ':' + port + '/v1/sys/seal-status'}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - keystore: '${keystore}'
            - keystore_password: '${keystore_password}'
            - content_type: '${content_type}'
            - proxy_password: '${proxy_password}'
            - headers: "${'X-VAULT-Token: ' + x_vault_token}"
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - error_message: '${error_message}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_sealed_status
    - get_sealed_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .sealed
        publish:
          - sealed: "${''.join( c for c in return_result if  c not in '\"[]' )}"
          - return_code: '${return_code}'
          - exception: '${exception}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - sealed: '${sealed}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
    - response_headers: '${response_headers}'
    - exception: '${exception}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      interogate_vault_server:
        x: 113
        y: 100
      get_sealed_status:
        x: 316
        y: 100
        navigate:
          0467f955-f44a-7ade-0854-8b224dc359b1:
            targetId: 17f1e303-4855-913c-223b-61d82c44a815
            port: SUCCESS
    results:
      SUCCESS:
        17f1e303-4855-913c-223b-61d82c44a815:
          x: 529
          y: 92

#!!
#! @input hostname: Vault FQDN
#! @input port: Vault Port
#! @input protocol: Vault Protocol
#! @input x_vault_token: Vault Token
#! @input key: key optional A single master share key
#! @input reset: reset optional A boolean; if true, the previously-provided unseal keys are discarded from memory and the unseal process is reset.
#!!#
namespace: io.cloudslang.demos.vault
flow:
  name: unseal
  inputs:
    - hostname
    - port
    - protocol
    - x_vault_token:
        sensitive: true
    - key:
        required: false
    - reset:
        required: false
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
    - compute_unseal_body:
        do:
          io.cloudslang.demos.vault.compute_unseal_body:
            - unseal_key: '${key}'
            - unseal_reset: '${reset}'
        publish:
          - json_body: '${return_result}'
          - return_code: '${return_code}'
          - error_message: '${error_message}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: interogate_vault_to_unseal
    - interogate_vault_to_unseal:
        do:
          io.cloudslang.base.http.http_client_put:
            - url: "${protocol + '://' + hostname + ':' + port + '/v1/sys/unseal'}"
            - headers: "${'X-VAULT-Token: ' + x_vault_token}"
            - content_type: '${content_type}'
            - body: '${json_body}'
        publish:
          - return_result: '${return_result}'
          - error_message: '${error_message}'
          - return_code: '${return_code}'
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_progress
    - get_progress:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .progress
        publish:
          - progress: "${''.join( c for c in return_result if  c not in '\"[]' )}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - sealed: '${sealed}'
    - progress: '${progress}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      compute_unseal_body:
        x: 82
        y: 89
      interogate_vault_to_unseal:
        x: 304
        y: 81
      get_sealed_status:
        x: 502
        y: 82
      get_progress:
        x: 694
        y: 81
        navigate:
          00bfbc2f-6e8c-8a40-97b0-035126178b3e:
            targetId: 17f1e303-4855-913c-223b-61d82c44a815
            port: SUCCESS
    results:
      SUCCESS:
        17f1e303-4855-913c-223b-61d82c44a815:
          x: 873
          y: 91

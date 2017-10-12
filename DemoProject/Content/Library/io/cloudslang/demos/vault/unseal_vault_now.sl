#!!
#! @input hostname: Vault FQDN
#! @input port: Vault Port
#! @input protocol: Vault Protocol
#! @input x_vault_token: Vault Token
#! @input keys: keys, required, a list of keys to unseal vault
#!!#
namespace: io.cloudslang.demos.vault
flow:
  name: unseal_vault_now
  inputs:
    - hostname
    - port
    - protocol
    - x_vault_token:
        sensitive: true
    - keys:
        required: true
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
    - unseal:
        loop:
          for: i in keys
          do:
            io.cloudslang.demos.vault.unseal:
              - hostname: '${hostname}'
              - port: '${port}'
              - protocol: '${protocol}'
              - x_vault_token: '${x_vault_token}'
              - key: '${i}'
          break:
            - FAILURE
          publish:
            - sealed: '${sealed}'
            - progress: '${progress}'
            - return_result: '${return_result}'
            - return_code: '${return_code}'
            - error_message: '${error_message}'
            - status_code: '${status_code}'
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
      unseal:
        x: 107
        y: 83
        navigate:
          686247cd-82c2-4226-6eed-de4a62b72a5c:
            targetId: 17f1e303-4855-913c-223b-61d82c44a815
            port: SUCCESS
    results:
      SUCCESS:
        17f1e303-4855-913c-223b-61d82c44a815:
          x: 341
          y: 90

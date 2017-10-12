namespace: io.cloudslang.demos.vmware
flow:
  name: get_advanced_details
  inputs:
    - host
    - port:
        required: false
    - protocol:
        default: https
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - auth_type:
        default: basic
        required: false
    - proxy_host:
        required: false
    - proxy_port:
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
    - kerberos_conf_file:
        required: false
    - kerberos_login_conf_file:
        required: false
    - kerberos_skip_port_for_lookup:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - winrm_max_envelop_size:
        default: '153600'
        required: false
    - winrm_locale:
        default: en-US
        required: false
    - operation_timeout:
        default: '60'
        required: false
  workflow:
    - get_os_information:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password: '${password}'
            - proxy_host: '${proxy_host}'
            - auth_type: '${auth_type}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
            - kerberos_conf_file: '${kerberos_conf_file}'
            - kerberos_login_conf_file: '${kerberos_login_conf_file}'
            - kerberos_skip_port_for_lookup: '${kerberos_skip_port_for_lookup}'
            - keystore: '${keystore}'
            - keystore_password: '${keystore_password}'
            - winrm_locale: '${winrm_locale}'
            - script: '${Get-WmiObject Win32_OperatingSystem}'
            - winrm_max_envelop_size: '${winrm_max_envelop_size}'
        publish:
          - stderr: '${stderr}'
          - os_info: '${return_result}'
        navigate:
          - FAILURE: get_service_list
          - SUCCESS: get_service_list
    - get_service_list:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password: '${password}'
            - proxy_host: '${proxy_host}'
            - auth_type: '${auth_type}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
            - kerberos_conf_file: '${kerberos_conf_file}'
            - kerberos_login_conf_file: '${kerberos_login_conf_file}'
            - kerberos_skip_port_for_lookup: '${kerberos_skip_port_for_lookup}'
            - keystore: '${keystore}'
            - keystore_password: '${keystore_password}'
            - winrm_locale: '${winrm_locale}'
            - script: '${Get-Process}'
            - winrm_max_envelop_size: '${winrm_max_envelop_size}'
        publish:
          - stderr: '${stderr}'
          - service_list: '${return_result}'
        navigate:
          - FAILURE: get_cpu
          - SUCCESS: get_cpu
    - get_cpu:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password: '${password}'
            - proxy_host: '${proxy_host}'
            - auth_type: '${auth_type}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
            - kerberos_conf_file: '${kerberos_conf_file}'
            - kerberos_login_conf_file: '${kerberos_login_conf_file}'
            - kerberos_skip_port_for_lookup: '${kerberos_skip_port_for_lookup}'
            - keystore: '${keystore}'
            - keystore_password: '${keystore_password}'
            - winrm_locale: '${winrm_locale}'
            - script: '${Get-WmiObject Win32_Processor}'
            - winrm_max_envelop_size: '${winrm_max_envelop_size}'
        publish:
          - stderr: '${stderr}'
          - cpu: '${return_result}'
        navigate:
          - SUCCESS: send_mail
          - FAILURE: send_mail
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: smtp3.hpe.com
            - port: '25'
            - from: ooautomation@hpe.com
            - to: andrei-vasile.truta@hpe.com
            - subject: "${'Details related to' + host +' received'}"
            - body: "${os_info + '\\n' cpu + '\\n' + service_list}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_os_information:
        x: 66
        y: 119
      get_service_list:
        x: 252
        y: 117
      get_cpu:
        x: 443
        y: 118
      send_mail:
        x: 619
        y: 118
        navigate:
          6f0fa2b4-2786-f526-a561-2546191b5a44:
            targetId: 11dadbc3-25c3-51fd-aaca-43591a8c88ba
            port: SUCCESS
    results:
      SUCCESS:
        11dadbc3-25c3-51fd-aaca-43591a8c88ba:
          x: 814
          y: 123

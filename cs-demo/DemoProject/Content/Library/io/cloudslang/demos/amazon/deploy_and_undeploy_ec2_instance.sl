########################################################################################################################
#!!
#! @description: This flow launches a new EC2 instance and after 1 minute removes it
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services.
#! @input proxy_port: Proxy server port used to access the provider services
#!                    Default: '8080'
#!
#! @output instance_id: The ID of the newly created instance
#! @output return_result: Contains the instance details in case of success, error message otherwise
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) was successfully deployed
#! @result FAILURE: Error deploying instance
#!!#
########################################################################################################################

namespace: io.cloudslang.demos.amazon

flow:
  name: deploy_and_undeploy_ec2_instance

  inputs:
    - identity:
        default: "${get_sp('amazon.ec2.identity')}"
        sensitive: true
    - credential:
        default: "${get_sp('amazon.ec2.credential')}"
        sensitive: true
    - proxy_host: 'web-proxy.corp.hpecorp.net'
    - proxy_port: '8080'

  workflow:
    - deploy_ec2_instance:
        do:
          io.cloudslang.amazon.aws.ec2.deploy_instance:
            - identity
            - credential
            - proxy_host
            - proxy_port
            - image_id: 'ami-0b33d91d'
            - key_tags_string: 'Name,Location'
            - value_tags_string: 'OODemo,LiveDemo'
            - instance_type: 't2.micro'
            - subnet_id: 'subnet-4713b230'
            - key_pair_name: 'AlexKP'
        publish:
          - instance_id
          - return_code
          - return_result
          - ip_address
          - exception
        navigate:
          - FAILURE: on_failure
          - SUCCESS: keep_the_instance_alive_for_X_seconds

    - keep_the_instance_alive_for_X_seconds:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '60'
        publish:
          - message
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: undeploy_ec2_instance

    - undeploy_ec2_instance:
        do:
          io.cloudslang.amazon.aws.ec2.undeploy_instance:
            - identity
            - credential
            - proxy_host
            - proxy_port
            - instance_id
        publish:
          - return_code
          - exception
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - on_failure:
        - write_to_file:
            do:
              io.cloudslang.base.filesystem.write_to_file:
                - file_path: "${C:\\Logs\\OO\\deploy_and_undeploy_ec2_instance.log}"
                - text: '${exception}'

  outputs:
      - instance_id
      - return_code
      - exception

  results:
    - FAILURE
    - SUCCESS

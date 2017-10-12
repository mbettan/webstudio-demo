########################################################################################################################
#!!
#! @output return_result: Command standard output
#!!#
########################################################################################################################

namespace: io.cloudslang.demos.generic

flow:
  name: run_command
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: myd-vm01415.hpswlabs.adapps.hp.com
            - command: uname -a
            - username: "${get_sp('ssh.username')}"
            - password: "${get_sp('ssh.password')}"
        publish:
          - return_result: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 137
        y: 7
        navigate:
          be7acce6-ae62-3dcf-abf3-5c51f0590773:
            targetId: 3d0ad8db-4d80-bf55-223c-ca7355af62a1
            port: SUCCESS
    results:
      SUCCESS:
        3d0ad8db-4d80-bf55-223c-ca7355af62a1:
          x: 321
          y: 6

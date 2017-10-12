namespace: io.cloudslang.demos.generic
flow:
  name: error_handling
  inputs:
    - command: uname
    - host: myd-vm01415.hpswlabs.adapps.hp.com
    - arg: '-a'
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: myd-vm01415.hpswlabs.adapps.hp.com
            - command: "${command + ' ' + arg}"
            - username: "${get_sp('ssh.username')}"
            - password: "${get_sp('ssh.password')}"
        publish:
          - return_result: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - on_failure:
        - send_mail:
            do:
              io.cloudslang.base.mail.send_mail:
                - hostname: smtp3.hpe.com
                - port: '25'
                - from: revnic@hpe.com
                - to: revnic@hpe.com
                - subject: 'Hello from OO Designer!'
                - body: The Force is strong with you
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 118
        y: 14
        navigate:
          016e6ffb-d488-633b-6879-41ad780c8a6c:
            targetId: 254b50d5-a9d7-1386-20b8-548f5b544250
            port: SUCCESS
    results:
      SUCCESS:
        254b50d5-a9d7-1386-20b8-548f5b544250:
          x: 310.2727355957031
          y: 18.284103393554688

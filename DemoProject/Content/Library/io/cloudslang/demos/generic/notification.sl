namespace: io.cloudslang.demos.generic
flow:
  name: notification
  inputs:
    - from
    - to
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time: []
        publish:
          - current_time: '${output}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: send_mail
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: smtp3.hpe.com
            - port: '25'
            - from: '${from}'
            - to: '${to}'
            - subject: The Force is strong with you
            - body: "${'Today is ' + current_time}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - on_failure:
        - run_command:
            do:
              io.cloudslang.demos.generic.run_command: []
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_time:
        x: 33
        y: 63
      send_mail:
        x: 259
        y: 57
        navigate:
          a11186e6-a742-bd83-6f72-8fd9c8a2e319:
            targetId: 32f939e7-31ce-3521-bc05-b98e1a6f9e51
            port: SUCCESS
    results:
      SUCCESS:
        32f939e7-31ce-3521-bc05-b98e1a6f9e51:
          x: 477
          y: 60

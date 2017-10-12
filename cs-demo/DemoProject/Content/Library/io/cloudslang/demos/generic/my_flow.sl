namespace: io.cloudslang.demos.generic
flow:
  name: my_flow
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
            - from: revnic@hpe.com
            - to: revnic@hpe.com
            - subject: The Force is strong with you
            - body: '${"Today " + current_time}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_time:
        x: 135.27273559570312
        y: 57.465911865234375
      send_mail:
        x: 361
        y: 52
        navigate:
          5a7b131b-b7cb-ef0f-c111-1029015e6e8b:
            targetId: a0f60ce6-4276-c252-6bf3-8cf3ac54f970
            port: SUCCESS
    results:
      SUCCESS:
        a0f60ce6-4276-c252-6bf3-8cf3ac54f970:
          x: 559
          y: 62

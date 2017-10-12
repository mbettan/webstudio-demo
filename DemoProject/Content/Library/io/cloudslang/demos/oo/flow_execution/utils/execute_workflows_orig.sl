namespace: io.cloudslang.demos.oo.flow_execution.utils
flow:
  name: execute_workflows_orig
  inputs:
    - response_headers:
        default: ' '
        private: true
  workflow:
    - execute_workflow:
        loop:
          for: "i in 'io.cloudslang.demos.oo.flow_execution.utils.uuid_generator,io.cloudslang.demos.oo.flow_execution.utils.random_number_generator,a02c64ec-1355-4932-961c-32579dfc4d9f,06fe8531-868b-4e79-aa7a-13a5e30a66ec'"
          do:
            io.cloudslang.demos.oo.flow_execution.utils.execute_workflow_orig:
              - flowUuid: '${i}'
              - headers: '${response_headers}'
          break:
            - OTHER
          publish:
            - return_result: '${return_result}'
            - flow_details: '${flow_details}'
            - response_headers: '${response_headers}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - OTHER: send_mail
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: '${smtp3.hpe.com}'
            - port: '${25}'
            - from: '${oo_automation@hpe.com}'
            - to: '${andrei-vasile.truta@hpe.com}'
            - subject: '${Flow sequence did not complete}'
            - body: '${return_result + flow_details}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: RESPORT_SENT
  results:
    - FAILURE
    - SUCCESS
    - RESPORT_SENT
extensions:
  graph:
    steps:
      execute_workflow:
        x: 168
        y: 107
        navigate:
          22b29ce0-9091-cdd4-d38c-08f607e0cf69:
            targetId: 2ca2e3fb-f860-31c8-b7d4-281b7cdd4fc4
            port: SUCCESS
      send_mail:
        x: 384
        y: 288
        navigate:
          dde1ab8b-056b-20d5-73f9-0a8d23d68ae7:
            targetId: 410bfeb3-9b57-bd92-5703-ece87226eaff
            port: SUCCESS
    results:
      SUCCESS:
        2ca2e3fb-f860-31c8-b7d4-281b7cdd4fc4:
          x: 397
          y: 80
      RESPORT_SENT:
        410bfeb3-9b57-bd92-5703-ece87226eaff:
          x: 584
          y: 291

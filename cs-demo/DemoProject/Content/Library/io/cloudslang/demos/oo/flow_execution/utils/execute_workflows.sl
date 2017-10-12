namespace: io.cloudslang.demos.oo.flow_execution.utils
flow:
  name: execute_workflows
  workflow:
    - execute_workflow_testing:
        loop:
          for: "i in 'io.cloudslang.demos.oo.flow_execution.utils.uuid_generator,io.cloudslang.demos.oo.flow_execution.utils.random_number_generator,io.cloudslang.demos.oo.flow_execution.utils.custom_formatter,io.cloudslang.demos.oo.flow_execution.utils.get_current_time'"
          do:
            io.cloudslang.demos.oo.flow_execution.execute_workflow:
              - flow_uuid: '${i}'
              - flowUuid: '${i}'
          break:
            - OTHER
          publish:
            - return_result: '${run_status}'
            - flow_details: '${run_details_output}'
            - triggered_flow: '${triggered_flow}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - OTHER: send_mail
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: smtp3.hpe.com
            - port: '25'
            - from: ooautomation@hpe.com
            - to: andrei-vasile.truta@hpe.com
            - subject: "${'Flow sequence did not complete for flow ' + triggered_flow}"
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
      execute_workflow_testing:
        x: 157
        y: 96
        navigate:
          16e039c0-f533-bfff-ccce-2a881db23f67:
            targetId: 2ca2e3fb-f860-31c8-b7d4-281b7cdd4fc4
            port: SUCCESS
      send_mail:
        x: 384
        y: 287
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

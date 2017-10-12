namespace: io.cloudslang.demos.oo.flow_execution
flow:
  name: execute_workflows
  workflow:
    - execute_workflow:
        loop:
          for: "i in 'io.cloudslang.demos.oo.flow_execution.utils.uuid_generator,io.cloudslang.demos.oo.flow_execution.utils.random_number_generator,io.cloudslang.demos.oo.flow_execution.utils.custom_formatter,io.cloudslang.demos.oo.flow_execution.utils.get_current_time'"
          do:
            io.cloudslang.demos.oo.flow_execution.execute_workflow:
              - flow_uuid: '${i}'
          break:
            - OTHER
          publish:
            - run_status: '${run_status}'
            - run_details_output: '${run_details_output}'
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
            - subject: "${'Flow sequence did not complete for flow  '+ triggered_flow}"
            - body: '${run_status + run_details_output}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: REPORT_SENT
  results:
    - FAILURE
    - SUCCESS
    - REPORT_SENT
extensions:
  graph:
    steps:
      execute_workflow:
        x: 133
        y: 92
        navigate:
          e4f4f71e-53b8-a9db-4ba2-af0d373e4aed:
            targetId: 197ce14d-1936-73f9-d3f8-ff3a8cb430f1
            port: SUCCESS
      send_mail:
        x: 322.6000061035156
        y: 214.59999084472656
        navigate:
          f78354b5-e9db-1d31-dfd7-54e7b3654079:
            targetId: 69bfd30d-ed23-fd1d-086a-38bd0efe5d43
            port: SUCCESS
    results:
      SUCCESS:
        197ce14d-1936-73f9-d3f8-ff3a8cb430f1:
          x: 334.6000061035156
          y: 46.59999084472656
      REPORT_SENT:
        69bfd30d-ed23-fd1d-086a-38bd0efe5d43:
          x: 492.5999755859375
          y: 183.59999084472656

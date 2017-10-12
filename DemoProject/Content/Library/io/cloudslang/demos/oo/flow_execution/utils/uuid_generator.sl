namespace: io.cloudslang.demos.oo.flow_execution.utils
flow:
  name: uuid_generator
  workflow:
    - uuid_generator:
        do:
          io.cloudslang.base.utils.uuid_generator: []
        publish:
          - new_uuid: '${new_uuid}'
        navigate:
          - SUCCESS: sleep
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '15'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - uuid: '${new_uuid}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      uuid_generator:
        x: 75
        y: 87
      sleep:
        x: 172
        y: 314
        navigate:
          e96c339a-11f5-ae05-dc7c-90943fc4c0bc:
            targetId: 88a5f0c7-bb96-a0e9-4d9d-0a02560bef0e
            port: SUCCESS
    results:
      SUCCESS:
        88a5f0c7-bb96-a0e9-4d9d-0a02560bef0e:
          x: 296
          y: 73

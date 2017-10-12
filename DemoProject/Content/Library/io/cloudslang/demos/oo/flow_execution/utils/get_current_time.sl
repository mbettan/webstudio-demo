namespace: io.cloudslang.demos.oo.flow_execution.utils
flow:
  name: get_current_time
  workflow:
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time: []
        publish:
          - current_time: '${output}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - current_time: '${current_time}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_time:
        x: 72
        y: 102
        navigate:
          8d8f90c0-ab1c-afb4-140b-d154d14171b0:
            targetId: 96e7e530-9e24-6b9a-3514-1ba44a16afa0
            port: SUCCESS
    results:
      SUCCESS:
        96e7e530-9e24-6b9a-3514-1ba44a16afa0:
          x: 229
          y: 77

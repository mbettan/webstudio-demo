namespace: io.cloudslang.demos.debugger
flow:
  name: invalid_flow_runtime_ex
  workflow:
    - length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${1,2,3}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      length:
        x: 175
        y: 60
        navigate:
          c8899055-1950-fde8-b67a-8bc49b8bb84f:
            targetId: 8698dc67-2912-ced3-a3d8-c20b1708af71
            port: SUCCESS
    results:
      SUCCESS:
        8698dc67-2912-ced3-a3d8-c20b1708af71:
          x: 361
          y: 44

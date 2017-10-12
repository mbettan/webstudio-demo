namespace: io.cloudslang.demos.debugger
flow:
  name: invalid_flow
  workflow:
    - length:
        do:
          io.cloudslang.base.lists.length: []
        navigate:
          - FAILURE: on_failure
  results:
    - FAILURE
extensions:
  graph:
    steps:
      length:
        x: 111
        y: 70

namespace: io.cloudslang.demos.oo.flow_execution.utils
flow:
  name: custom_formatter
  workflow:
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '0'
            - max: '${1000}'
        publish:
          - random_number: '${random_number}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - random_number: '${random_number}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      random_number_generator:
        x: 62
        y: 123
        navigate:
          9bf90574-d9a8-699c-1158-c14a53b321c1:
            targetId: 1705424e-56e8-bf52-6495-f6fa18cfc30f
            port: SUCCESS
    results:
      SUCCESS:
        1705424e-56e8-bf52-6495-f6fa18cfc30f:
          x: 241
          y: 101

namespace: io.cloudslang.demos.debugger
flow:
  name: simple_flow
  workflow:
    - string_length:
        do:
          io.cloudslang.base.strings.length:
            - origin_string: '123'
        publish:
          - length
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      string_length:
        x: 245
        y: 79
        navigate:
          7bf25df5-0416-ee9b-475b-b08e05b86012:
            targetId: ee16ac1b-40f4-01f2-7eac-d6e1848fe664
            port: SUCCESS
    results:
      SUCCESS:
        ee16ac1b-40f4-01f2-7eac-d6e1848fe664:
          x: 432
          y: 76

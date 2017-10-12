namespace: io.cloudslang.demos.debugger
flow:
  name: invalid_flow_runtime_ex_outputs
  inputs:
    - list: '1,2,3'
  workflow:
    - length:
        do:
          io.cloudslang.base.strings.length:
            - origin_string: '123'
        publish: []
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - flow_output_0: '${length}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      length:
        x: 61
        y: 106
        navigate:
          e4b7150b-6a1d-9349-647e-023ec4442adc:
            targetId: bc9167d6-a6fd-af42-459e-0a104f854626
            port: SUCCESS
    results:
      SUCCESS:
        bc9167d6-a6fd-af42-459e-0a104f854626:
          x: 257
          y: 111

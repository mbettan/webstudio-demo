namespace: io.cloudslang.demos.debugger
flow:
  name: simple_flow_loop
  workflow:
    - length:
        loop:
          for: 'i in 1,2,3'
          do:
            io.cloudslang.base.strings.length:
              - origin_string: dummy
          break: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      length:
        x: 118
        y: 119
        navigate:
          f1a75489-4d2c-048f-7daa-17c45bbab768:
            targetId: 13c873ee-4219-f717-f04f-ed3f9cde769b
            port: SUCCESS
    results:
      SUCCESS:
        13c873ee-4219-f717-f04f-ed3f9cde769b:
          x: 298
          y: 125

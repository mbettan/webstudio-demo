namespace: io.cloudslang.demos.debugger
flow:
  name: simple_flow_parallel_loop
  workflow:
    - length:
        parallel_loop:
          for: 'i in 4,5,6'
          do:
            io.cloudslang.base.strings.length:
              - origin_string: dummy
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      length:
        x: 98
        y: 98
        navigate:
          f8c042cc-f972-7979-4322-d8480eb1ed4d:
            targetId: 811d6005-12a6-a346-da82-bf535540f526
            port: SUCCESS
    results:
      SUCCESS:
        811d6005-12a6-a346-da82-bf535540f526:
          x: 296
          y: 93

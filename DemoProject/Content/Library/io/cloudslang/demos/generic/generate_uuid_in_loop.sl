namespace: io.cloudslang.demos.generic
flow:
  name: generate_uuid_in_loop
  workflow:
    - generate_uuid:
        loop:
          for: 'i in list(range(1,100))'
          do:
            io.cloudslang.base.math.generate_uuid: []
          break: []
          publish:
            - uuid: '${result}'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      generate_uuid:
        x: 246
        y: 160
        navigate:
          d1ae8d94-a30f-ab89-efe3-bf0272dfb17f:
            targetId: c5e2e588-9b5b-d220-fe52-21707e339285
            port: SUCCESS
    results:
      SUCCESS:
        c5e2e588-9b5b-d220-fe52-21707e339285:
          x: 512
          y: 175

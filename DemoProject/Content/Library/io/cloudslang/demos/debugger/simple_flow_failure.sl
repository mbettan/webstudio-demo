namespace: io.cloudslang.demos.debugger
flow:
  name: simple_flow_failure
  workflow:
    - length:
        do:
          io.cloudslang.base.strings.length:
            - origin_string: '123'
        publish:
          - length
        navigate:
          - SUCCESS: string_equals
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${length}'
            - second_string: '1'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - on_failure:
        - handle_default_failure:
            do:
              io.cloudslang.base.utils.sleep:
                - seconds: '2'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      length:
        x: 105
        y: 112
      string_equals:
        x: 352
        y: 88
        navigate:
          38f31f14-963b-4b59-41bd-a02f0e536f84:
            targetId: 1b0a6f0b-8416-0965-0b13-c4da3e8ad287
            port: SUCCESS
    results:
      SUCCESS:
        1b0a6f0b-8416-0965-0b13-c4da3e8ad287:
          x: 489
          y: 106

#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Executes an HTTP POST call towards a specified endpoint.
#!               By default the flow allows you to specify anything in the request body of the HTTP POST call
#!               (also known as a POST RAW call). You can also specify the Content-Type header for POST RAW request
#!               using the 'content-type' input
#!
#! @input url: URL to which the call is made
#! @input auth_type: Optional - type of authentication used to execute the request on the target server
#!                   Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#! @input username: Optional - username used for URL authentication; for NTLM authentication, the required format is
#!                  'domain\user'
#! @input password: Optional - password used for URL authentication
#! @input proxy_host: Optional - proxy server used to access the web site
#! @input proxy_port: Optional - proxy server port - Default: '8080'
#! @input proxy_username: Optional - user name used when connecting to the proxy
#! @input proxy_password: Optional - proxy server password associated with the <proxyUsername> input value
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input keystore: Optional - the pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: Optional - the password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input request_character_set: Optional - character encoding to be used for the HTTP request body; should not
#!                               be provided for method=GET, HEAD, TRACE - Default: 'ISO-8859-1'
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input headers: Optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":"
#!                 Format: According to HTTP standard for headers (RFC 2616)
#!                 Example: 'Accept:text/plain'
#! @input query_params: Optional - list containing query parameters to append to the URL
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input body: Optional - string to include in body for HTTP PATCH operation
#! @input content_type: Optional - content type that should be set in the request header, representing the
#!                      MIME-type of the data in the message body
#!                      Default: 'text/plain'
#! @input method: HTTP method used - Default: 'POST'
#!
#! @output return_result: the response of the operation in case of success or the error message otherwise
#! @output error_message: return_result if status_code is not contained in interval between '200' and '299'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: status code of the HTTP call
#! @output response_headers: response headers string from the HTTP Client REST call
#!!#
########################################################################################################################

namespace: io.cloudslang.demos.oo.flow_execution.utils

imports:
  http: io.cloudslang.base.http

flow:
  name: http_client_post
  inputs:
    - url
    - auth_type:
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
    - keystore:
        default: "${get_sp('io.cloudslang.base.http.keystore')}"
        required: false
    - keystore_password:
        default: "${get_sp('io.cloudslang.base.http.keystore_password')}"
        required: false
        sensitive: true
    - request_character_set:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - headers:
        required: false
    - query_params:
        required: false
    - body:
        required: false
    - content_type:
        default: text/plain
        required: false
    - method:
        default: POST
        private: true
    - connections_max_total: '100'
    - connections_max_per_root: '100'
  workflow:
    - http_client_action_post:
        do:
          http.http_client_action:
            - url
            - auth_type
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots: 'false'
            - x_509_hostname_verifier: strict
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - request_character_set
            - headers
            - query_params
            - body
            - use_cookies: 'false'
            - keep_alive: 'false'
            - connections_max_per_root: '${connections_max_per_root}'
            - content_type
            - method
            - connections_max_total: '${connections_max_total}'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - response_headers
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_action_post:
        x: 100
        y: 150
        navigate:
          a1f27107-81ee-e885-f1f5-4972e941aefb:
            targetId: a241b672-e4b0-92a9-5442-9299f6bf2b2d
            port: SUCCESS
    results:
      SUCCESS:
        a241b672-e4b0-92a9-5442-9299f6bf2b2d:
          x: 400
          y: 150

require 'httparty'

module KlickmailApi
  class Connector
    DEFAULT_SERVICE = 'http://www.klickmail.com.br/api'

    def initialize(service = DEFAULT_SERVICE)
      @service = service
    end

    def login(username, password)
      data = { username: username, password: password }

      result = request('account/login', :post, data)
      set_session(result)

      result
    end

    def request(path, method = :get, data = {})
      headers = {}
      headers = request_header if @sessid

      http_request(path, method, data, headers).parsed_response
    end

    private

    def set_session(data)
      @session_name = data['session_name']
      @sessid = data['sessid']
    end

    def request_header
      { 'Cookie' => "#{@session_name}=#{@sessid}",
        'Content-Type' => 'application/x-www-form-urlencoded'
       }
    end

    def http_request(path, method, data, headers)
      HTTParty.public_send(method, "#{@service}/#{path}", body: data, headers: headers, timeout: 3)
    end
  end
end
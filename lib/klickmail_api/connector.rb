require 'httparty'
require 'uri'

module KlickmailApi
  class Connector
    include HTTParty

    DEFAULT_SERVICE = 'http://www.klickmail.com.br/api'

    def initialize(service = DEFAULT_SERVICE)
      uri = URI(service)
      @service = service
      @host = uri.host
      @port = get_port(uri.scheme)
    end

    def login(username, password)
      data = { username: username, password: password }

      response = http_request('account/login', 'POST', data)
      
      if valid_login?(response)
        set_session(response['result'])
        return true
      end

      return false
    end

    private

    def valid_login?(response)
      response['result'] && response['result']['sessid']
    end

    def set_session(data)
      @sessionName = data['sessioName']
      @sessid = data['sessid']
    end

    def get_port(scheme)
      return 80 if scheme == 'http'
      return 443 if scheme == 'https'
    end

    def http_request(path, method = 'GET', data = nil)
      HTTParty.post("#{@service}/#{path}", body: data)
    end
  end
end
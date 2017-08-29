require 'httparty'

module KlickmailApi
  class Connector
    include HTTParty

    DEFAULT_SERVICE = 'http://www.klickmail.com.br/api'

    def initialize(service = DEFAULT_SERVICE)
      @service = service
    end

    def login(username, password)
      data = { username: username, password: password }

      response = http_request('account/login', 'POST', data)

      return response['result']
    end

    private

    def valid_login?(response)
      response['result'] && response['result']['sessid']
    end

    def set_session(data)
      @sessionName = data['sessioName']
      @sessid = data['sessid']
    end

    def http_request(path, method = 'GET', data = nil)
      HTTParty.post("#{@service}/#{path}", body: data)
    end
  end
end
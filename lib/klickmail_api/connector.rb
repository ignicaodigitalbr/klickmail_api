
module KlickmailApi
  class Connector
    include HTTParty
    DEFAULT_SERVICE = 'http://api.klickmail.com.br'

    def initialize(service = DEFAULT_SERVICE)
      uri = URI(service)
      @host = uri.host
      @port = get_port(uri.scheme)
    end

    def login(username, password)
      data = { username: username, password: password }

      response = http_request('account/login', 'POST', data);

      if valid_login?(response)
        set_session(response.data)
        return true
      end

      return false
    end

    private

    def valid_login?(response)
      !response.error && response.data && response.data.sessid
    end

    def set_session(data)
      @sessionName = data.sessionName
      @sessid = data.sessid
    end

    def get_port(scheme)
      return 80 if scheme == 'http'
      return 443 if scheme == 'https'
    end

    def http_request(path, method = 'GET', data = nil)
      http.post("#{@host}/#{path}", body: {data})
    end
  end
end
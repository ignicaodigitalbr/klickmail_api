require 'httparty'

module KlickmailApi
  class Client
    def initialize
      @connector = Connector.new
    end

    def login(username, password)
      @connector.login(username, password)
    end

    def index_fields
      @connector.request('field')
    end
  end
end
require "spec_helper"
require 'webmock/rspec'

RSpec.describe KlickmailApi::Connector do
  let(:header) { {'content_type': 'application/xml'} }
  let(:url) { 'http://www.klickmail.com.br/api' }
  let(:connector) { KlickmailApi::Connector.new }

  describe '#login' do
    before do
      WebMock.stub_request(:post, "#{url}/account/login")
        .to_return(status: status, body: response, headers: header)
    end

    context 'when the request is valid' do 
      let(:response) do 
        "<?xml version='1.0' encoding='utf-8'?>
          <result>
            <sessid>sessid</sessid>
            <session_name>sessionname</session_name>
          </result>"
      end
      let(:status) { 200 }
      
      subject { connector.login('username', 'password') }

      it { is_expected.to be(true) }
    end

    context 'when the request is invalid' do 
      let(:response) do 
        "<?xml version='1.0' encoding='utf-8'?>
          <result>O nome de usuário ou a senha são inválidos.</result>"
      end
      let(:status) { 401 }

      subject { connector.login('wrong_username', 'wrong_password') }

      it { is_expected.to be(false) }
    end
  end
end

   

require "spec_helper"
require 'webmock/rspec'

RSpec.describe KlickmailApi::Client do
  let(:header) { {'content_type': 'application/xml'} }
  let(:url) { 'http://www.klickmail.com.br/api' }
  let(:client) { KlickmailApi::Client.new }

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
      let(:result) { {"sessid"=>"sessid", "session_name"=>"sessionname"} }

      subject { client.login('username', 'password') }

      it { expect(subject['result']).to eq(result) }
    end

    context 'when the request is invalid' do
      let(:response) do
        "<?xml version='1.0' encoding='utf-8'?>
          <result>O nome de usuário ou a senha são inválidos.</result>"
      end
      let(:status) { 401 }
      let(:result) { 'O nome de usuário ou a senha são inválidos.' }

      subject { client.login('wrong_username', 'wrong_password') }

      it { expect(subject['result']).to eq(result) }
    end
  end

  describe '#index_fields' do
    before do
      WebMock.stub_request(:get, "#{url}/field")
        .to_return(status: status, body: response, headers: header)
    end

    context 'when the request is valid' do
      let(:response) do
        "<?xml version='1.0' encoding='utf-8'?>
          <result>
            <field1>field1</field1>
            <field2>field2</field2>
            <field3>field3</field3>
          </result>"
      end
      let(:status) { 200 }
      let(:result) do
        { "field1"=>"field1",
          "field2"=>"field2",
          "field3"=>"field3" }
      end

      subject { client.index_fields }

      it { expect(subject['result']).to eq(result) }
    end
  end
end
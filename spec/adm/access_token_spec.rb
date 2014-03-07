require 'spec_helper'
require 'ostruct'

describe ADM::AccessToken do
  describe ".fetch" do
    context "given valid response" do
      let(:request_data_response_body) {{
        "scope"=>"messaging:push",
        "token_type"=>"bearer",
        "expires_in"=>3600, "access_token"=>"Atc|ABC123"
      }}

      before do
        ADM::AccessToken.stub(request_data: request_data_response_body)
      end

      it "requests data" do
        ADM::AccessToken.should_receive(:request_data)
        ADM::AccessToken.fetch
      end

      it "returns access token object token" do
        token = ADM::AccessToken.fetch
        expect(token).to be_kind_of(ADM::AccessToken)
        expect(token.token).to eq("Atc|ABC123")
      end
    end

    context "given invalid response" do
      let(:request_data_response_body) {{
        "error"=>"invalid_scope",
        "error_description"=>"The request has an invalid parameter : scope"
      }}

      before do
        ADM::AccessToken.stub(request_data: request_data_response_body)
      end

      it "raises token error" do
        expect {
          ADM::AccessToken.fetch
        }.to raise_error(ADM::AccessToken::TokenGetError)
      end
    end
  end

  describe ".request_data" do
    let(:client_id)     { "amzn1.application-oa2-client.7bf819" }
    let(:client_secret) { "ca6a25bf3aaeee" }
    let(:request)       { double("request") }
    let(:body)          { "{\"scope\":\"messaging:push\",\"token_type\":\"bearer\",\"expires_in\":3600,\"access_token\":\"Atc|MQEBIHxLVIrRi7OsGohSrjq0UM1TcVJorvpf0BIw5ot3Ls2RQkGn0IaVcTDq2aO1IMUu1nk18qe1z8hGzhc_ZGfeAlvmEWUlg8ehqeRyN5-n2F-EqsYn81jaQGRuYTnI1xzdogbbTV0vHo4LGq7ytsqq4SFGwDeFMTOdnLkgeTRz_6h64m5ndDnXAo1Wk5Pu9ocaNHQ\"}"}
    let(:response)      { OpenStruct.new(body: body) }
    let(:response_keys) { ["scope", "token_type", "expires_in", "access_token"] }
    let(:url)           { "https://api.amazon.com/auth/O2/token" }

    before do
      stub_request(:post, url).to_return(status: 200, body: body)
    end

    it "creates request" do
      Typhoeus::Request.should_receive(:new).and_call_original
      ADM::AccessToken.request_data(client_id, client_secret)
    end

    it "returns response body in json format" do
      MultiJson.should_receive(:load).with(response.body).and_call_original
      data = ADM::AccessToken.request_data(client_id, client_secret)
      expect(data).to_not be_empty
      expect(data).to be_kind_of(Hash)
      expect(data.keys).to eq(response_keys)
    end
  end

  describe ".get_token" do
    let(:fetch_data) { OpenStruct.new(token: "Atc|ABC123") }

    before do
      ADM::AccessToken.stub(fetch: fetch_data)
    end

    it "fetches data and returns token" do
      ADM::AccessToken.should_receive(:fetch)
      ADM::AccessToken.get_token
    end

    it "returns token" do
      token = ADM::AccessToken.get_token
      expect(token).to_not be_empty
      expect(token).to be_kind_of(String)
      expect(token).to eq("Atc|ABC123")
    end
  end
end

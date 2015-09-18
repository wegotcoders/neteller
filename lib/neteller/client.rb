module Neteller
  class Client
    include HTTParty

    def self.config=(config)
      @@config = config
    end

    def self.config
      @@config
    end

    def initialize
      @client_id, @client_secret, @webhook_key = @@config.to_a
    end

    def pay!(payment)
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{obtain_access_token['accessToken']}"
      }
      response = HTTParty.post("https://test.api.neteller.com/v1/orders", :body => payment.to_h.to_json, :headers => headers )
      Response.new(response).to_h
    end

    def obtain_access_token
      HTTParty.post("https://test.api.neteller.com/v1/oauth2/token?grant_type=client_credentials", :headers => {'Content-Type' => 'application/json', 'Cache-control' => 'no-cache' }, :basic_auth => { username: @client_id, password: @client_secret})
    end

    def order_lookup(url)
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{obtain_access_token['accessToken']}"
      }
      HTTParty.get(url[0..-9], :headers => headers).to_h
    end
  end
end

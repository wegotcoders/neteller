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
      @client_id, @client_secret, @webhook_key, @base_uri = @@config.to_a
    end

    def headers
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{obtain_access_token['accessToken']}"
      }
    end

    def pay!(order)
      response = self.class.post("#{@base_uri}/v1/orders", :body => order.to_h.to_json, :headers => headers )
      Response.new(response).to_h
    end

    def transfer_out(payment)
      response = self.class.post("#{@base_uri}/v1/transferOut", :body => payment.to_h.to_json, :headers => headers)
      response.to_json
    end

    def obtain_access_token
      self.class.post("#{@base_uri}/v1/oauth2/token?grant_type=client_credentials",
                    :headers => { 'Content-Type' => 'application/json', 'Cache-control' => 'no-cache' },
                    :basic_auth => { username: @client_id, password: @client_secret }).to_h
    end

    def order_lookup(url)
      self.class.get(url, :headers => headers).to_h
    end
  end
end

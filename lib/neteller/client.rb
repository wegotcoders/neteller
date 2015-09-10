require 'base64'

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
      @client_id, @client_secret, @merchant_ref_id = @@config.to_a
    end

    def pay!(payment)
      headers = {
        "Content-Type" => 'application/json',
        "Authorization" => "Bearer #{obtain_access_token}"
       }
      HTTParty.post("https://api.neteller.com/v1/orders", :body => payment.to_h.to_json, :headers => headers )
    end

    def obtain_access_token
      HTTParty.post("https://api.neteller.com/v1/oauth2/token?grant_type=client_credentials", :basic_auth => Base64.encode("#{@client_id}:#{@client_secret}"))
    end
  end
end

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
      @client_id, @secret_id, @merchant_ref_id = @@config.to_a
    end

    def pay!(payment)
      headers = {
        "Content-Type" => 'application/json',
        "Authorization" => 'ACCESS_TOKEN'
       }
      HTTParty.post("https://api.neteller.com/v1/orders", :body => payment.to_h.to_json, :headers => headers )
    end
  end
end

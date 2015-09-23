module Neteller
  class Config
    attr_accessor :client_id, :client_secret, :merchant_ref_id, :webhook_key, :live_mode

    def initialize
      yield self
      Neteller::Client.config = self
    end

    def to_a
      [@client_id, @client_secret, @webhook_key, base_uri]
    end

    def base_uri
      "https://#{subdomain}api.neteller.com"
    end

    private
    def subdomain
      self.live_mode ? '' : 'test.'
    end
  end
end

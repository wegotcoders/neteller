module Neteller
  class Config
    attr_accessor :client_id, :client_secret, :merchant_ref_id, :webhook_key

    def initialize
      yield self
      Neteller::Client.config = self
    end

    def to_a
      [@client_id, @client_secret, @webhook_key]
    end
  end
end

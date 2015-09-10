module Neteller
  class Config
    attr_accessor :client_id, :client_secret, :merchant_ref_id

    def initialize
      yield self
      Neteller::Client.config = self
    end

    def to_a
      [@client_id, @client_secret, @merchant_ref_id]
    end
  end
end

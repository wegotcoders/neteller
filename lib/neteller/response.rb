module Neteller
  class Response
    def initialize(response)
      @response = response
    end

    def to_h
      {
        order_id: @response["orderId"],
        merchant_ref_id: @response["merchantRefId"],
        total_amount: @response["totalAmount"],
        currency: @response["currency"],
        lang: @response["lang"],
        status: @response["status"],
        payment_url: @response["links"][0]["url"]
      }
    end
  end
end

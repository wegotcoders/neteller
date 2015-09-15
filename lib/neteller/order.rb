module Neteller
  class Order
    def initialize(options={})
      options.each { |name, value| instance_variable_set("@#{name}", value) }
    end

    def to_h
      {
        order: {
          merchantRefId: @merchant_ref_id,
          totalAmount: @total_amount,
          currency: @currency,
          lang: @lang,
          redirects: [
            {
              rel: "on_success",
              returnKeys: [],
              uri: @redirects_success
            },
            {
              rel: "on_cancel",
              returnKeys: [],
              uri: @redirects_cancel
            }
          ]
        }
      }
    end
  end
end

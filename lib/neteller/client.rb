module Neteller
  class Client
    include HTTParty
    def pay!(payment)
      headers = {
        "Content-Type" => 'application/json',
        "Authorization" => 'ACCESS_TOKEN'
       }
      HTTParty.post("https://api.neteller.com/v1/orders", :body => payment.to_h.to_json, :headers => headers )
    end
  end
end

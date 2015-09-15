require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Response" do
  before do
    response = {
      "orderId"=>"ORD_95d43a0e-c477-4b35-9c32-6fed3573f806",
      "merchantRefId"=>"b289539081c1b99b082d238dec8a4420",
      "totalAmount"=>1000,
      "currency"=>"USD",
      "lang"=>"en_US",
      "status"=>"pending",
      "redirects"=>
      [{"rel"=>"on_success", "uri"=>"http://localhost:3000/payments/neteller/payments"},
       {"rel"=>"on_cancel", "uri"=>"http://localhost:3000/payments/neteller/payments"}],
      "links"=>
      [{"url"=>"https://test.api.neteller.com/v1/checkout/ORD_95d43a0e-c477-4b35-9c32-6fed3573f806", "rel"=>"hosted_payment", "method"=>"GET"},
       {"url"=>"https://test.api.neteller.com/v1/orders/ORD_95d43a0e-c477-4b35-9c32-6fed3573f806", "rel"=>"self", "method"=>"GET"}]
    }
    @response = Neteller::Response.new(response)
  end

  it "should parse the response" do
    hash = {
      order_id: "ORD_95d43a0e-c477-4b35-9c32-6fed3573f806",
      merchant_ref_id: "b289539081c1b99b082d238dec8a4420",
      total_amount: 1000,
      currency: "USD",
      lang: "en_US",
      status: "pending",
      payment_url:"https://test.api.neteller.com/v1/checkout/ORD_95d43a0e-c477-4b35-9c32-6fed3573f806"
    }
    @response.to_h.should eq(hash)
  end
end

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Order" do
  before do
    Neteller::Config.new do |config|
      config.client_id = '123'
      config.client_secret = '123'
      config.merchant_ref_id = '123'
    end
  end

  let (:order) do
    Neteller::Order.new({
      merchant_ref_id: '123123',
      total_amount: 3599,
      currency: 'EUR',
      lang: 'en_US',
      ip: '123.123.123',
      redirects_success: "https://example.com/success.html",
      redirects_cancel: "https://example.com/cancel.html",
      item_name: '100 Iconic Coins'
    })
  end

  let (:order_params) do
    {
      order: {
        "merchantRefId": "123123",
        "totalAmount": 3599,
        "currency": "EUR",
        "lang": "en_US",
        "items": [{"name": "100 Iconic Coins"}],
        "redirects": [
          {
            "rel": "on_success",
            "returnKeys": [],
            "uri": "https://example.com/success.html"
          },
          {
            "rel": "on_cancel",
            "returnKeys": [],
            "uri": "https://example.com/cancel.html"
          }
        ]
      }
    }
  end

  it "renders an Order in JSON format required by Neteller" do
    (order.to_h).should eq(order_params)
  end
end

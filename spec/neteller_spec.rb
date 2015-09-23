require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Order" do
  before do
    Neteller::Config.new do |config|
      config.client_id = '123'
      config.client_secret = '123'
    end
    @client = Neteller::Client.new
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

  let (:transfer_out) do
    Neteller::TransferOut.new({
      payee_profile_email: "john.doe@email.com",
      transaction_amount: 2500,
      transaction_currency: "EUR",
      transaction_merchant_ref_id: "20140203113703",
      message: "sample message"
    })
  end

  let (:transfer_out_params) do
    {
      payeeProfile: {
        email: "john.doe@email.com"
      },
      transaction: {
        amount: 2500,
        currency: "EUR",
        merchantRefId: "20140203113703"
      },
      message: "sample message"
    }
  end

  let (:order_params) do
    {
      order: {
        merchantRefId: "123123",
        totalAmount: 3599,
        currency: "EUR",
        lang: "en_US",
        #items: [{name: "100 Iconic Coins"}],
        redirects: [
          {
            rel: "on_success",
            returnKeys: [],
            uri: "https://example.com/success.html"
          },
          {
            rel: "on_cancel",
            returnKeys: [],
            uri: "https://example.com/cancel.html"
          }
        ]
      }
    }
  end

  it "renders an Order in JSON format required by Neteller" do
    (order.to_h).should eq(order_params)
  end

  it "renders an TranserOut  in JSON format required by Neteller" do
    (transfer_out.to_h).should eq(transfer_out_params)
  end

  describe "Client" do
    it 'has all the settings' do
      Neteller::Client.config.client_id.should eq('123')
      Neteller::Client.config.client_secret.should eq('123')
    end

    describe "pay!" do
      before do
        @oauth_headers = {
          :headers => { 'Content-Type' => 'application/json', 'Cache-control' => 'no-cache' },
          :basic_auth => { username: Neteller::Client.config.client_id, password: Neteller::Client.config.client_secret }
        }
        @order_headers = {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer 0.AQAAAU_5c42VAAAAAAAEk-Cgfb6_fTYKJklHoYAVZ290.ieEd7IKQB2edBF-ffC0GJeEGi2A"
        }

        @order_pay_response = {"orderId"=>"ORD_6a9d720a-833d-416d-8864-d5f46e108fc2",
                              "merchantRefId"=>"123123",
                              "totalAmount"=>3599,
                              "currency"=>"EUR",
                              "lang"=>"en_US",
                              "status"=>"pending",
                              "redirects"=>[{"rel"=>"on_success", "uri"=>"https://example.com/success.html"}, {"rel"=>"on_cancel", "uri"=>"https://example.com/cancel.html"}],
                              "links"=>
        [{"url"=>"https://test.api.neteller.com/v1/checkout/ORD_6a9d720a-833d-416d-8864-d5f46e108fc2", "rel"=>"hosted_payment", "method"=>"GET"},
         {"url"=>"https://test.api.neteller.com/v1/orders/ORD_6a9d720a-833d-416d-8864-d5f46e108fc2", "rel"=>"self", "method"=>"GET"}]}
      end

      it "sends a POST to the Neteller endpoint" do
        Neteller::Client.should_receive(:post).with("https://test.api.neteller.com/v1/oauth2/token?grant_type=client_credentials", @oauth_headers).
          and_return({"accessToken"=>"0.AQAAAU_5c42VAAAAAAAEk-Cgfb6_fTYKJklHoYAVZ290.ieEd7IKQB2edBF-ffC0GJeEGi2A", "tokenType"=>"Bearer", "expiresIn"=>300})
        Neteller::Client.should_receive(:post).with("https://test.api.neteller.com/v1/orders", :body => order.to_h.to_json, :headers => @order_headers).and_return{ @order_pay_response }
        Neteller::Client.new.pay!(order)
      end
    end
  end
end

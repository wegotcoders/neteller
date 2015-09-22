module Neteller
  class TransferOut
    def initialize(options)
      options.each { |name, value| instance_variable_set("@#{name}", value) } unless options.nil?
    end

    def to_h
      {
        payeeProfile: {
          email: @payee_profile_email
        },
        transaction: {
          amount: @transaction_amount,
          currency: @transaction_currency,
          merchantRefId: @transaction_merchant_ref_id,
        },
        message: @message
      }
    end
  end
end

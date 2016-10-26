describe Wirecard::Elastic::Request::Transaction do

  subject(:creditcard_valid_response) { Wirecard::Elastic::Request::Transaction.new(MERCHANT_CREDITCARD, TRANSACTION_CREDITCARD, PAYMENT_METHOD_CREDITCARD).response }
  subject(:upop_valid_response) { Wirecard::Elastic::Request::Transaction.new(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP).response }
  subject(:upop_invalid_response) { Wirecard::Elastic::Request::Transaction.new(MERCHANT_UPOP, "wrong", PAYMENT_METHOD_UPOP).response }

  context "#response" do

    context "when we use valid datas" do

      # basic check
      it { expect(upop_valid_response.raw).to be_a(Hash) }
      it { expect(upop_valid_response.raw[:payment][:"transaction-state"]).to eql("success") }

      # format output
      it { expect(upop_valid_response).to be_a(Wirecard::Elastic::Response::Transaction) }
      it { expect(upop_valid_response.transaction_state).to eql(:success) }

      context "using upop" do
        it { expect(upop_valid_response.transaction_type).to eql(:debit) }
      end

      context "using creditcard" do
        it { expect(creditcard_valid_response.transaction_type).to eql(:purchase) }
      end

    end

    context "when we use invalid datas" do

      # raise errors systematically
      it { expect{upop_invalid_response}.to raise_error(Wirecard::Elastic::Error) }
      it { expect{upop_invalid_response.raw}.to raise_error(Wirecard::Elastic::Error) }

    end

  end

end

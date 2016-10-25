describe Wirecard::Elastic::Transaction do

  subject(:valid_response) { Wirecard::Elastic::Transaction.new(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP).response }
  subject(:unvalid_response) { Wirecard::Elastic::Transaction.new(MERCHANT_UPOP, "wrong", PAYMENT_METHOD_UPOP).response }

  context "#response" do

    context "valid datas" do

      # basic check
      it { expect(valid_response.raw).to be_a(Hash) }
      it { expect(valid_response.raw[:payment][:"transaction-state"]).to eql("success") }

      # format output
      it { expect(valid_response).to be_a(Wirecard::Elastic::Utils::ResponseFormat) }
      it { expect(valid_response.transaction_state).to eql(:success) }

      # upop specific
      it { expect(valid_response.transaction_type).to eql(:debit) }

    end

    context "unvalid datas" do

      # raise errors systematically
      it { expect{unvalid_response}.to raise_error(Wirecard::Elastic::Error) }
      it { expect{unvalid_response.raw}.to raise_error(Wirecard::Elastic::Error) }

    end

  end

end

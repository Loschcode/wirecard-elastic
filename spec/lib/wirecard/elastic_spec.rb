describe Wirecard::Elastic do

  context ".transaction" do

    context "when invalid configuration" do

      context "wrong engine url" do
      end

      context "wrong username" do
      end

      context "wrong password" do
      end

    end

    context "when valid transaction" do
    end

    context "when invalid transaction" do
    end

  end

  context ".refund" do

    context "when valid parent transaction" do
    end

    context "when invalid parent transaction" do
    end

  end

  # it "can access essential variables after creation" do
  #
  #   wirecard = Wirecard::Elastic.transaction(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP)
  #   expect(wirecard.response.transaction_state).to eql(:success)
  #
  # end

end

describe Wirecard::Elastic do

  it "can access essential variables after creation" do

    wirecard = Wirecard::Elastic.transaction(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP)
    expect(wirecard.response.transaction_state).to eql(:success)

  end

end

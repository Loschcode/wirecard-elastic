describe Wirecard::Elastic do

  it "can access essential variables after creation" do

    valid_merchant = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
    valid_transaction = "af3864e1-0b2b-11e6-9e82-00163e64ea9f"
    valid_payment_method = :upop

    wirecard = Wirecard::Elastic.transaction(valid_merchant, valid_transaction, valid_payment_method)
    expect(wirecard.response.transaction_state).to eql(:success)

  end

end

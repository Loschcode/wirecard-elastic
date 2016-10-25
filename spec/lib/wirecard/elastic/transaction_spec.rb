describe Wirecard::Elastic::Transaction do

  # UNION PAY TEST MERCHANT AND TRANSACTION
  TEST_MERCHANT = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a" unless defined? TEST_MERCHANT
  TEST_TRANSACTION = "af3864e1-0b2b-11e6-9e82-00163e64ea9f" unless defined? TEST_TRANSACTION
  TEST_PAYMENT_METHOD = :upop unless defined? TEST_PAYMENT_METHOD


  context "#response" do

    it 'should return a response hash' do

        response = Wirecard::Elastic::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION, TEST_PAYMENT_METHOD).response.raw
        expect(response).to be_a(Hash)
        expect(response[:payment][:"transaction-state"]).to eql("success")

    end

    it 'should return a formatted response' do

        response = Wirecard::Elastic::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION, TEST_PAYMENT_METHOD).response
        expect(response).to be_a(Wirecard::Elastic::Utils::ResponseFormat)
        expect(response.transaction_state).to eql(:success)

    end

    it 'should not find the transaction and raise an error' do

        expect{Wirecard::Elastic::Transaction.new(TEST_MERCHANT, "fake-transaction", TEST_PAYMENT_METHOD).response.raw}.to raise_error(Wirecard::Elastic::Error)

    end

  end

  context "#status" do

    it 'should return the status' do

        transaction_state = Wirecard::Elastic::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION, TEST_PAYMENT_METHOD).response.transaction_state
        expect(transaction_state).to eql(:success)

    end

=begin TODO: we should redo this and place the response tests in a new tests series.
    it 'should raise a status error' do

      VCR.use_cassette("wirecard-api-transaction", :record => :new_episodes) do

        transaction = Wirecard::Elastic::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION)
        allow(transaction).to receive(:response) { OpenStruct.new }
        binding.pry
        expect{transaction.response.status}.to raise_error(Wirecard::Elastic::Error)

        transaction = Wirecard::Elastic::Transaction.new(TEST_MERCHANT, TEST_TRANSACTION)
        allow(transaction).to receive(:response) { {:payment => {:"transaction-state" => "fake-status"}} }
        expect{transaction.response.status}.to raise_error(Wirecard::Elastic::Error)
      end

    end
=end
  end

end

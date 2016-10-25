describe Wirecard::Elastic::Refund do

  #TEST_MERCHANT = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a"
  #TEST_TRANSACTION = "af3864e1-0b2b-11e6-9e82-00163e64ea9f"

  TEST_MERCHANT = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a" unless defined? TEST_MERCHANT
  TEST_TRANSACTION = "6bbaa57c-8e36-47de-8035-10121256d39b" unless defined? TEST_TRANSACTION
  TEST_PAYMENT_METHOD = :upop unless defined? TEST_PAYMENT_METHOD

  context "#response" do

    it 'should return a response hash' do

      #response = Wirecard::Elastic::Refund.new(TEST_MERCHANT, TEST_TRANSACTION, TEST_PAYMENT_METHOD).response.raw

    end

  end

end

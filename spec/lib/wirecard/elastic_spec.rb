describe Wirecard::Elastic do

  context ".transaction" do

    context "when invalid configuration" do

      context "wrong engine url" do

        before(:each) { Wirecard::Elastic.config { |config| config.upop[:engine_url] = 'wrong' } }
        after(:each) { Wirecard::Elastic.config { |config| config.upop[:engine_url] = UPOP_ENGINE_URL } }

        subject(:response) { Wirecard::Elastic.transaction(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP).response }

        it { expect{response}.to raise_error(Wirecard::Elastic::ConfigError) }

      end

      context "wrong username" do

        before(:each) { Wirecard::Elastic.config { |config| config.upop[:username] = 'wrong' } }
        after(:each) { Wirecard::Elastic.config { |config| config.upop[:username] = UPOP_USERNAME } }

        subject(:response) { Wirecard::Elastic.transaction(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP).response }

        it { expect{response}.to raise_error(Wirecard::Elastic::Error) }

      end

      context "wrong password" do

        before(:each) { Wirecard::Elastic.config { |config| config.upop[:password] = 'wrong' } }
        after(:each) { Wirecard::Elastic.config { |config| config.upop[:password] = UPOP_PASSWORD } }

        subject(:response) { Wirecard::Elastic.transaction(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP).response }

        it { expect{response}.to raise_error(Wirecard::Elastic::Error) }


      end

    end

    context "when valid transaction" do

      subject(:transaction) { Wirecard::Elastic.transaction(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP) }
      it { expect(transaction).to be_a(Wirecard::Elastic::Request::Transaction) }
      it { expect(transaction.response).to be_a(Wirecard::Elastic::Response::Transaction) }
      it { expect(transaction.response.transaction_state).to eql(:success) }

    end

    context "when invalid transaction" do

      subject(:response) { Wirecard::Elastic.transaction(MERCHANT_UPOP, 'wrong', PAYMENT_METHOD_UPOP).response }
      it { expect{response}.to raise_error(Wirecard::Elastic::Error) }


    end

  end

  context ".refund" do

    context "when valid parent transaction" do

      subject(:transaction) { Wirecard::Elastic.refund(MERCHANT_UPOP, TRANSACTION_UPOP, PAYMENT_METHOD_UPOP) }
      it { expect(transaction).to be_a(Wirecard::Elastic::Request::Refund) }
      it { expect(transaction.response).to be_a(Wirecard::Elastic::Response::Refund) }
      it { expect(transaction.response.transaction_state).to eql(:success) }

    end

    context "when invalid parent transaction" do

      subject(:transaction) { Wirecard::Elastic.refund(MERCHANT_UPOP, 'wrong', PAYMENT_METHOD_UPOP) }
      it { expect{transaction.response}.to raise_error(Wirecard::Elastic::Error) }

    end

  end

end

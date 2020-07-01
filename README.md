
# Wirecard Elastic

This library  integrates the Elastic API for Wirecard Payment Service in Ruby. This library could actually be extended to manage any Elastic API service provider.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wirecard-elastic'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wirecard-elastic

## Configuration

Add the following lines into your `config/initializer/` folder

```ruby
# use this to configure anything
# on the wirecard elastic api gem
Wirecard::Elastic.config do |config|

  # the engine URL must be a full URL to the elastic engine you use
  # you can add different credentials for each type of payment (Credit Card, China Union Pay, ...)
  config.creditcard = {
    :username   => "USERNAME FOR CREDIT CARD",
    :password   => "PASSWORD FOR CREDIT CARD",
    :engine_url => "http://api.engine-url.com/"
  }
  config.upop = {
    :username   => "USERNAME FOR UNION PAY",
    :password   => "PASSWORD FOR UNION PAY",
    :engine_url => "http://api.engine-url.com/"
  }

end
```

## Usage

Recover a transaction or/and refund from the API.

```ruby
# Any of the following instructions work for both transaction and refund request
# the payment method can be either :upop or :creditcard for now
response = Wirecard::Elastic.transaction("MERCHANT ID", "TRANSACTION ID", "PAYMENT METHOD").response
response = Wirecard::Elastic.refund("MERCHANT ID", "PARENT TRANSACTION ID", "PAYMENT METHOD").response
```

You can get any result from the API. The results will be processed and converted to symbol / underscore depending on the response current mapping

```ruby
# different response datas from the API
response.transaction_state
response.transaction_type
response.request_status
response.requested_amount
# ... and so forth
```

Check [Elastic Payment Documentation](http://docs.elastic-payments.com/) for more details about the requests / responses

You can catch the done request itself without processed response like so

```ruby
# get request
request = Wirecard::Elastic.transaction("MERCHANT ID", "TRANSACTION ID", "PAYMENT METHOD").request
# check the exact query final URL
request.query
# see the raw result of the request
request.feedback
```

You can also check if the transaction / refund was successful via this small shortcut. It will raise an error if not, you can then use whatever functionality you could normally use

```ruby
safe_transaction = Wirecard::Elastic.transaction("MERCHANT ID", "TRANSACTION ID", "PAYMENT METHOD").safe
safe_transaction.request
safe_transaction.response
```

Concrete use in your code could look like this

```ruby
def check
  puts "Transaction current state : #{response.transaction_state}"
end

# errors are basically raised and
# must be catch by yourself
def response
  @response ||= Wirecard::Elastic.refund(order_payment.merchant_id, order_payment.transaction_id, order_payment.payment_method).response
rescue Wirecard::Elastic::Error => exception
  raise Error, "A problem occurred : #{exception}"
end
```

## Development

I created this library for my company. It lacks several functionalities but it's way enough for us ; everything is easily extendable so don't hesitate to add your own needed methods to it.

You will notice there a lot of sub-functionalities which isn't quoted in the instructions. For instance, there's a XML body builder with template system which can be easily extended to other file formats if needed.

It was originally created for [Wirecard](https://www.wirecard.com/) but I see no restriction to use it for any other service with the elastic structure.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wirecard-elastic/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

[Laurent Schaffner](http://www.laurentschaffner.com)

## License

MIT License.

## Changelog

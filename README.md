# Euro Currency Conversion Rate

[![Build Status](https://travis-ci.org/gsingharoy/euro_currency_conversion_rate.svg?branch=master)](https://travis-ci.org/gsingharoy/euro_currency_conversion_rate) [![Gem Version](https://badge.fury.io/rb/euro_currency_conversion_rate.svg)](http://badge.fury.io/rb/euro_currency_conversion_rate)

This is a useful gem which returns the current exchange rates of various currencies with respect to euro. This gets the latest exchange rates from the [European Central Bank SOAP service](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html).

This gem has no dependency to Nokogiri and uses httparty to parse the xml response.

For support with the Ruby class money please use the gem [here](https://github.com/RubyMoney/eu_central_bank).

## Installation
```shell
gem install euro_currency_conversion_rate
```

## Usage

```shell
require 'euro_currency_conversion_rate'
conversion_rate = EuroCurrencyConversionRate.rate('USD')
# => 1.1389
```
To get all the exchange rates
```shell
conversion_rates_hash = EuroCurrencyConversionRate.rates
# => {:usd=>1.1389, :jpy=>136.33, :bgn=>1.9558, :czk=>27.401, :dkk=>7.464, :gbp=>0.727, :huf=>307.55, :pln=>4.0615, :ron=>4.4465, :sek=>9.3836, :chf=>1.0482, :nok=>8.3815, :hrk=>7.5325, :rub=>56.0016, :try=>2.9385, :aud=>1.4228, :brl=>3.4161, :cad=>1.3733, :cny=>7.0661, :hkd=>8.8283, :idr=>14967.91, :ils=>4.3569, :inr=>72.5115, :krw=>1236.94, :mxn=>17.1188, :myr=>4.065, :nzd=>1.5356, :php=>50.596, :sgd=>1.5056, :thb=>37.977, :zar=>13.5051}
```

To get exchange rates of some currencies
```shell
conversion_rates_hash = EuroCurrencyConversionRate.rates([:usd, :inr, :chf])
# => {:usd=>1.1389, :chf=>1.0482, :inr=>72.5115}
```

Please not that it is not important to pass the currencies as symbols. They can be strings too and are case insensitive.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-awesome-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-awesome-feature`)
5. Create new Pull Request
6. Relax and enjoy a beer

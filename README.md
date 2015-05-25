# Euro Currency Conversion Rate

This is a useful gem which returns the current exchange rates of various currencies with respect to euro. This gets the latest exchange rates from the [European Central Bank SOAP service](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html). 

This gem has no dependency to Nokogiri and uses httparty to parse the xml response. 

For support with the Ruby class money please use the gem [here](https://github.com/RubyMoney/eu_central_bank). 

## Installation
```shell
gem install euro_currency_conversion_Rate
```

## Usage

```shell
require 'euro_currency_conversion_Rate'
conversion_rate = EuroCurrencyConversionrate.rate('USD')
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-awesome-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-awesome-feature`)
5. Create new Pull Request
6. Relax and enjoy a beer

Gem::Specification.new do |spec|
  spec.name        = 'euro_currency_conversion_rate'
  spec.version     = '0.1.0'
  spec.date        = '2015-05-25'
  spec.summary     = "Euro Currency Conversion rate service"
  spec.description = "A simple service which returns the current exchange rate of a currency w.r.t. euro"
  spec.authors     = ["Gaurav Singha Roy"]
  spec.email       = 'neogauravsvnit@gmail.com'
  spec.files       = ["lib/euro_currency_conversion_rate.rb"]
  spec.homepage    =
    'https://github.com/gsingharoy/euro_currency_conversion_rate'
  spec.license       = 'MIT'
  
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'httparty'
end
require 'httparty'

class EuroCurrencyConversionRate
  
  API_URL  = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'

  class << self

    # gets the latest exchange rate in float for a currency w.r.t. EUR
    #
    # Example:
    #   >> EuroCurrencyConversionRate.rate('USD')
    #   => 1.21
    #   
    #
    # Arguments:
    #   currency: (String)
    def rate(currency)
      return 1.0 if currency.upcase == 'EUR'
      currency_exchange_rate = currency_exchange_array.detect{ |ca| ca['currency'] == currency.upcase }
      currency_exchange_rate['rate'].to_f unless currency_exchange_rate.nil?
    end

    private

    def currency_exchange_array
      xml = raw_xml_response
      xml.parsed_response['Envelope']['Cube']['Cube']['Cube']
    end

    def raw_xml_response
      xml = HTTParty.get(API_URL)
      if xml.response.code == '200'
        xml
      else
        fail("could not retrieve xml response. Got response code #{xml.response.code}")
      end
    end
  end
end


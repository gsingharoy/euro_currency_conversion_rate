require 'httparty'

class EuroCurrencyConversionRate
  
  API_URL  = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'

  class << self

    def exchange_rate(currency)
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
        fail("could not retrieve xml response. Got error code #{xml.response.code}")
      end
    end
  end
end
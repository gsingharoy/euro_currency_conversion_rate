require 'httparty'

class EuroCurrencyConversionRate

  API_URL  = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'

  class << self

    # returns the latest exchange rate in float for a currency w.r.t. EUR
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

    # returns a hash containing the latest exchange rates for a list of currencies w.r.t EUR
    #
    #
    # Example:
    #   >> EuroCurrencyConversionRate.rates([:usd, :chf, :inr])
    #   => {:usd=>1.0978, :chf=>1.0349, :inr=>69.7761}
    #   >> EuroCurrencyConversionRate.rates
    #   => {:usd=>1.0978, :jpy=>133.39, :bgn=>1.9558, :czk=>27.372, :dkk=>7.4552, :gbp=>0.71, :huf=>307.71, :pln=>4.1075, :ron=>4.4539, :sek=>9.2425, :chf=>1.0349, :nok=>8.39, :hrk=>7.5383, :rub=>54.881, :try=>2.8665, :aud=>1.4023, :brl=>3.425, :cad=>1.3496, :cny=>6.8098, :hkd=>8.51, :idr=>14471.4, :ils=>4.269, :inr=>69.7761, :krw=>1204.41, :mxn=>16.7662, :myr=>3.9668, :nzd=>1.5025, :php=>48.958, :sgd=>1.4728, :thb=>36.882, :zar=>13.1034}
    #
    #
    # Arguments:
    #   currencies: (Array)
    def rates(currencies = [])
      currencies = currencies.map{ |c| c.to_s.upcase }
      if currencies.empty?
        result_arr = currency_exchange_array
      else
        result_arr = currency_exchange_array.select{ |ca| currencies.include?(ca['currency']) }
      end
      result_hash = {}
      result_arr.map{ |ra| result_hash[ra['currency'].downcase.to_sym] = ra['rate'].to_f }
      result_hash[:eur] = 1.0 if currencies.include?('EUR')
      result_hash
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


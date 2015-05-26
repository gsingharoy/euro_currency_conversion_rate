require 'spec_helper'

describe EuroCurrencyConversionRate do
  let(:sample_parsed_response) {
    {
      'Envelope' => {
        'Cube' => {
          'Cube' => {
            'Cube' => [
              {"currency"=>"USD", "rate"=>"1.1389"},
              {"currency"=>"JPY", "rate"=>"136.33"},
              {"currency"=>"BGN", "rate"=>"1.9558"},
              {"currency"=>"CZK", "rate"=>"27.401"},
              {"currency"=>"DKK", "rate"=>"7.4640"},
              {"currency"=>"GBP", "rate"=>"0.72700"},
              {"currency"=>"HUF", "rate"=>"307.55"},
              {"currency"=>"PLN", "rate"=>"4.0615"},
              {"currency"=>"RON", "rate"=>"4.4465"},
              {"currency"=>"SEK", "rate"=>"9.3836"},
              {"currency"=>"CHF", "rate"=>"1.0482"},
              {"currency"=>"NOK", "rate"=>"8.3815"},
              {"currency"=>"HRK", "rate"=>"7.5325"},
              {"currency"=>"RUB", "rate"=>"56.0016"},
              {"currency"=>"TRY", "rate"=>"2.9385"},
              {"currency"=>"AUD", "rate"=>"1.4228"},
              {"currency"=>"BRL", "rate"=>"3.4161"},
              {"currency"=>"CAD", "rate"=>"1.3733"},
              {"currency"=>"CNY", "rate"=>"7.0661"},
              {"currency"=>"HKD", "rate"=>"8.8283"},
              {"currency"=>"IDR", "rate"=>"14967.91"},
              {"currency"=>"ILS", "rate"=>"4.3569"},
              {"currency"=>"INR", "rate"=>"72.5115"},
              {"currency"=>"KRW", "rate"=>"1236.94"},
              {"currency"=>"MXN", "rate"=>"17.1188"},
              {"currency"=>"MYR", "rate"=>"4.0650"},
              {"currency"=>"NZD", "rate"=>"1.5356"},
              {"currency"=>"PHP", "rate"=>"50.596"},
              {"currency"=>"SGD", "rate"=>"1.5056"},
              {"currency"=>"THB", "rate"=>"37.977"},
              {"currency"=>"ZAR", "rate"=>"13.5051"}
            ]
          }
        }
      }
    }
  }
  before do
    xml_response = double(:xml_response,
                          parsed_response: sample_parsed_response,
                          response: double(:response, code: '200'))
    allow(HTTParty).to receive(:get).and_return xml_response
  end

  describe '::rate' do
    context "when currency is present in the response" do
      ['CHF', 'INR', 'NZD', 'USD'].each do |ca|
        it "returns non nil float exchange rate for #{ca}" do
          expect(EuroCurrencyConversionRate.rate(ca)).to be_a_kind_of Float
        end
      end
      context 'currency is in lower case' do
        ['chf', 'inr', 'Nzd', 'Usd'].each do |ca|
          it "returns non nil float exchange rate for #{ca}" do
            expect(EuroCurrencyConversionRate.rate(ca)).to be_a_kind_of Float
          end
        end
      end
      context 'when EUR is passed' do
        it 'returns 1.0' do
          expect(EuroCurrencyConversionRate.rate('EUR')).to eq 1.0
        end
      end
      context 'when currency passed is in sym' do
        it 'returns the correct rate' do
          expected_response = currency_rate_hash_from_sample_response
          available_currencies.map{ |ac| ac.downcase.to_sym }.each do |curr|
            expect(
              EuroCurrencyConversionRate.rate(curr)
            ).to eq expected_response[curr]
          end
        end
      end
    end
    context 'when currency is not present in the response' do
      it 'returns nil' do
        expect(EuroCurrencyConversionRate.rate('invalid_curr')).to eq nil
      end
    end
  end

  describe '::rates' do
    context 'when currencies are passed in the response' do
      context 'currencies are in string uppercase' do
        it 'returns the correct rates' do
          expect(
            EuroCurrencyConversionRate.rates(partial_available_currencies)
          ).to eq currency_rate_hash(partial_available_currencies)
        end
      end
      context 'currencies are in string lowercase' do
        it 'returns the correct rates' do
          expect(
            EuroCurrencyConversionRate.rates(partial_available_currencies.map{ |a| a.downcase })
          ).to eq currency_rate_hash(partial_available_currencies)
        end
      end
      context 'currencies are in symbols' do
        it 'returns the correct rates' do
          expect(
              EuroCurrencyConversionRate.rates(partial_available_currencies.map{ |a| a.downcase.to_sym })
          ).to eq currency_rate_hash(partial_available_currencies)
        end
      end
      context ':eur is present in call' do
        it 'returns 1.0' do
          expect(
            EuroCurrencyConversionRate.rates([:eur])
          ).to eq({ eur: 1.0 })
        end
      end
      context 'none of the currencies are present' do
        it 'returns {}' do
          expect(
            EuroCurrencyConversionRate.rates([:inv1, :inv2, :inv3])
          ).to eq({})
        end
      end
      # TODO
      # This test case might change as this feature is probably not correct
      context 'some of the currencies are not present' do
        it 'returns the currencies which are present' do
          expect(
              EuroCurrencyConversionRate.rates(
                partial_available_currencies.map{ |a| a.downcase.to_sym } + [:inv1, :inv2]
              )
          ).to eq currency_rate_hash(partial_available_currencies)
        end
      end
    end
    context 'when currencies are not passed in the response' do
      it 'returns all the rates' do
        expected_hash = currency_rate_hash_from_sample_response
        expected_hash.delete(:eur)
        expect(
          EuroCurrencyConversionRate.rates
        ).to eq expected_hash
      end
    end
  end

  def currency_rate_hash_from_sample_response
    sample_hash = { eur: 1.0 }
    sample_parsed_response['Envelope']['Cube']['Cube']['Cube'].map{
      |s| sample_hash[s['currency'].downcase.to_sym] = s['rate'].to_f
    }
    sample_hash
  end

  def currency_rate_hash(currencies)
    currencies = currencies.map{ |c| c.downcase.to_sym }
    rate_hash = {}
    all_hash = currency_rate_hash_from_sample_response
    currencies.map{ |c| rate_hash[c] = all_hash[c] }
    rate_hash
  end

  def available_currencies
    sample_parsed_response['Envelope']['Cube']['Cube']['Cube'].map{ |s| s['currency'] } + ['EUR']
  end

  def partial_available_currencies
    available_currencies[0..4]
  end
end
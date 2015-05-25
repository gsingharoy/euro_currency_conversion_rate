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

  describe '::exchange_rate' do
    context "when currency is present in the response" do
      ['CHF', 'INR', 'NZD', 'USD'].each do |ca|
        it "returns non nil float exchange rate for #{ca}" do
          expect(EuroCurrencyConversionRate.rate(ca)).to be_a_kind_of Float
        end
      end
      context 'currency is in lower case' do 
        ['chf', 'inr', 'nzd', 'usd'].each do |ca|
          it "returns non nil float exchange rate for #{ca}" do
            expect(EuroCurrencyConversionRate.rate(ca)).to be_a_kind_of Float
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
end
require 'app_helper'

describe 'visit unavailability method' do 
  let(:url){ "offenders/#{offender_id}/visits/unavailability" }

  context 'given a valid offender ID' do
    let(:offender_id){ ENV['NOMIS_API_OFFENDER_ID'] }

    # Bomb out if no offender_id is given - we need to know a valid
    # identifier for lots of methods, and there is no way of retrieving
    # one without knowing more corroborating details (by design)
    it 'has the required environment variables set' do
      expect(offender_id).to_not be_nil, "You must supply a valid NOMIS_API_OFFENDER_ID environment variable"
    end

    context 'given dates in YYYY-MM-DD format' do
      let(:params){ {dates: dates.map{|dt| dt.strftime("%Y-%m-%d")}} }
      
      context 'with at least one entry which is valid and in the future' do
        let(:dates){ [Time.now + 86400] }

        describe 'the response' do
          let(:response){ NOMIS::API::Request.new(path: url, params: params).execute }

          describe 'status' do
            it 'should be 200' do
              expect( response.status ).to eq("200")
            end
          end

          it 'has no error key' do
            expect( response.data.keys ).to_not include('error')
          end
        end
      end

    end
  end
end

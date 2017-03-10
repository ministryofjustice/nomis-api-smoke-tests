require 'app_helper'

describe 'visit unavailability method' do 
  let(:url){ "offenders/#{offender_id}" }

  context 'given a valid offender ID' do
    # TODO: this is a hard-coded ID from prod/pre-prod
    # so it will fail if this ID does not exist
    # need to find a way of getting a valid one from any
    # given DB
    let(:offender_id){ 1820518 }

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

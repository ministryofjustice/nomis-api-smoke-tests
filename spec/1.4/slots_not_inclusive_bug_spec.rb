require 'app_helper'

describe 'prison slots' do
  let(:url){ "prison/#{prison_id}/slots" }
  let(:prison_id){ ENV['NOMIS_API_PRISON_ID'] }

    # Bomb out if no prison_id is given - we need to know a valid
    # identifier for lots of methods, and there is no way of retrieving
    # one without knowing more corroborating details (by design)
    it 'has the required environment variables set' do
      expect(prison_id).to_not be_nil, "You must supply a valid NOMIS_API_PRISON_ID environment variable"
    end

  context 'given a start and end date' do
    let(:params){ {start_date: start_date, end_date: end_date} }

    context 'in the future' do
      # 86400 seconds in a day
      let(:start_date){ Time.now + 86400 }

      context 'both the same' do
        let(:end_date){ start_date }

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
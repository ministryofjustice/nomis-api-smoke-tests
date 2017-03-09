require 'app_helper'

describe 'prison slots' do
  let(:url){ 'prison/CFI/slots' }

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
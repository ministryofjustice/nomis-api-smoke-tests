require 'app_helper'

describe 'offender contact list method' do
  let(:url){ "offenders/#{offender_id}/visits/contact_list" }
  let(:offender_id){ ENV['NOMIS_API_OFFENDER_ID'] }
  let(:params){ {} }

  # Bomb out if no offender_id is given - we need to know a valid
  # identifier for lots of methods, and there is no way of retrieving
  # one without knowing more corroborating details (by design)
  it 'has the required environment variables set' do
    expect(offender_id).to_not be_nil, "You must supply a valid NOMIS_API_OFFENDER_ID environment variable"
  end

  describe 'the response' do
    let(:response){ NOMIS::API::Get.new(path: url, params: params).execute }

    describe 'status' do
      it 'should be 200' do
        expect( response.status ).to eq("200")
      end
    end

    it 'has no error key' do
      expect( response.data.keys ).to_not include('error')
    end

    describe 'returned data' do
      let(:data){ response.data }

      it 'has a contacts key' do
        expect(data.keys).to include('contacts')
      end

      describe 'the contacts key' do
        it 'is an array' do
          expect(data['contacts']).to be_a(Array)
        end
      end
    end
  end

end
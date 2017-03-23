require 'app_helper'

describe 'POST visit' do
  let(:url){ "offenders/#{offender_id}/visits/booking" }
  let(:offender_id){ ENV['NOMIS_API_OFFENDER_ID'] }

    # Bomb out if no offender_id is given - we need to know a valid
    # identifier for lots of methods, and there is no way of retrieving
    # one without knowing more corroborating details (by design)
    it 'has the required environment variables set' do
      expect(offender_id).to_not be_nil, "You must supply a valid NOMIS_API_OFFENDER_ID environment variable"
    end

  context 'given a lead_contact and a slot' do
    let(:params){ {lead_contact: lead_contact, slot: slot} }

    # to avoid creating actual visits when testing against prod,
    # we're sending parameters we KNOW are invalid, and testing 
    # that the error we get back is 400 Bad Request
    # (not 404, which would indicate either the method or the offender
    #  is not there)
    # TODO: figure out a more resilient yet still non-invasive test
    # ...could we get a test offender set up in a ghost prison?
    context 'that we know are invalid' do
      let(:lead_contact){ 0 }
      # 86400 seconds in a day - so this time yesterday
      let(:slot){ (Time.now - 86400).strftime("%Y-%m-%dT12:00/12:45") }

      describe 'the response' do
        let(:response){ NOMIS::API::Post.new(path: url, params: params).execute }

        describe 'status' do
          
          it 'should be 400' do
            expect( response.status ).to eq("400")
          end
        end

      end
    end
  end
end
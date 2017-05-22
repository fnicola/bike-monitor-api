require 'rails_helper'


RSpec.describe "stations api", :type => :request do
  describe "GET /stations" do
    it "responds succesfully with HTTP 200 status code" do
      VCR.use_cassette 'tfl/station_response' do
        get "/stations"
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context "when db is less than 5 min older" do
      let(:station) { FactoryGirl.create :station}

      it "returns the stations from the db" do
        allow(Station).to receive(:timeout_time).and_return 5.seconds
        VCR.use_cassette('tfl/stations_response', allow_playback_repeats: true) do
          get "/stations"
          updated_at = Station.first.created_at
          sleep 1
          get "/stations"
          expect(updated_at.utc.to_s).to eq(Station.first.created_at.utc.to_s)
        end
      end
    end

    context "when db is older than 5 min older" do
      it "returns the stations from the external api" do
        allow(Station).to receive(:timeout_time).and_return 1.seconds
        VCR.use_cassette('tfl/stations_response', allow_playback_repeats: true) do
          get "/stations"
          updated_at = Station.first.created_at
          sleep 1.5
          get "/stations"
          expect(updated_at.utc.to_s).not_to eq(Station.first.created_at.utc.to_s)
        end
      end
    end

  end
end

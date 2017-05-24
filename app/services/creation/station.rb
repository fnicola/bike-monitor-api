module Services
  module Creation
    class Station < BaseService

      attr_reader :timeout

      def initialize(timeout, options = {})
        super(options)
        @timeout = timeout
      end

      def allow?
        ::Station.all.empty? || (Time.now - ::Station.first.updated_at  > @timeout)
      end

      def perform_if_allowed
        request = Typhoeus::Request.new("https://api.tfl.gov.uk/bikepoint")
        hydra = Typhoeus::Hydra.new
        hydra.queue(request)
        hydra.run
        ::Station.destroy_all
        stations = JSON.parse(request.response.response_body)
        stations.each do |station|
          s = ::Station.create(name: station["commonName"])
          s.create_location(lat: station["lat"], lng: station["lon"])
        end
      end
    end
  end
end

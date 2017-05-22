require 'net/http'
class StationsController < ApplicationController
  before_action :set_station, only: [:show, :update, :destroy]

  # GET /stations
  def index
    timeout = Station.timeout_time
    if Station.all.empty? || (Time.now - Station.first.updated_at  > timeout)
      request = Typhoeus::Request.new("https://api.tfl.gov.uk/bikepoint")
      hydra = Typhoeus::Hydra.new
      hydra.queue(request)
      hydra.run
      Station.destroy_all
      stations = JSON.parse(request.response.response_body)
      stations.each do |station|
        s = Station.create(name: station["commonName"])
        s.create_location(lat: station["lat"], lng: station["lon"])
      end
    end
    @stations = Station.all

    render json: @stations
  end

  # GET /stations/1
  def show
    render json: @station
  end

  # POST /stations
  def create
    if @station.save
      render json: @station, status: :created, location: @station
    else
      render json: @station.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stations/1
  def update
    if @station.update(station_params)
      render json: @station
    else
      render json: @station.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stations/1
  def destroy
    @station.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def station_params
      params.fetch(:station, {})
    end
end

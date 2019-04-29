module Weathercom

class Location
  def initialize(lat, lng, client)
    @lat, @lng, @client = lat, lng, client
  end

  attr_reader :lat
  attr_reader :lng
  attr_reader :client

  def current_observation
    payload = client.get_json_with_cache("#{url_prefix}/observations/current.json")
    Observation.new(payload['observation'], Metadata.new(payload['metadata']))
  end

  def daily_forecasts_5
    payload = client.get_json_with_cache("#{url_prefix}/forecast/daily/5day.json?#{query}")
    payload['forecasts'].map do |info|
      DailyForecast.new(info, Metadata.new(payload['metadata']))
    end
  end

  def daily_forecasts_10
    payload = client.get_json_with_cache("#{url_prefix}/forecast/daily/10day.json?#{query}")
    payload['forecasts'].map do |info|
      DailyForecast.new(info, Metadata.new(payload['metadata']))
    end
  end

  alias :daily_forecasts :daily_forecasts_10

  def hourly_forecasts_240
    payload = client.get_json_with_cache("#{url_prefix}/forecast/hourly/240hour.json?#{query}")
    payload['forecasts'].map do |info|
      HourlyForecast.new(info, Metadata.new(payload['metadata']))
    end
  end

  alias :hourly_forecasts :hourly_forecasts_240

  # When Will It Rain Forecast
  def wwir_forecast
    payload = client.get_json_with_cache("#{url_prefix}/forecast/wwir.json?#{query}")
    WwirForecast.new(payload['forecast'], Metadata.new(payload['metadata']))
  end

  private

  def url_prefix
    "/v1/geocode/#{URI.encode(lat.to_s)}/#{URI.encode(lng.to_s)}"
  end

  def query
    "units=e"
  end
end

end

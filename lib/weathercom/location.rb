module Weathercom

class Location
  def initialize(lat, lng, client)
    @lat, @lng, @client = lat, lng, client
  end

  attr_reader :lat
  attr_reader :lng
  attr_reader :client

  def current_observation
    client.get_json("#{url_prefix}/observations/current.json")
  end

  def daily_forecast_5
    client.get_json("#{url_prefix}/forecast/daily/5day.json?#{query}")
  end

  def daily_forecast_10
    client.get_json("#{url_prefix}/forecast/daily/10day.json?#{query}")
  end

  alias :daily_forecast :daily_forecast_10

  def hourly_forecast_240
    client.get_json("#{url_prefix}/forecast/hourly/240hour.json?#{query}")
  end

  alias :hourly_forecast :hourly_forecast_240

  # When Will It Rain Forecast
  def wwir_forecast
    client.get_json("#{url_prefix}/forecast/wwir.json?#{query}")
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

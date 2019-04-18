module Weathercom

class Location
  def initialize(lat, lng, client)
    @lat, @lng, @client = lat, lng, client
  end

  attr_reader :lat
  attr_reader :lng
  attr_reader :client

  def current
    client.get_json("#{url_prefix}/observations/current")
  end

  def daily_5
    client.get_json("#{url_prefix}/forecast/daily/5day?#{query}")
  end

  def daily_10
    client.get_json("#{url_prefix}/forecast/daily/10day?#{query}")
  end

  alias :daily :daily_10

  def hourly_240
    client.get_json("#{url_prefix}/forecast/hourly/240hour?#{query}")
  end

  alias :hourly :hourly_240

  def wwir
    client.get_json("#{url_prefix}/forecast/wwir?#{query}")
  end

  private

  def url_prefix
    "/v1/geocode/#{URI.encode(lat)}/#{URI.encode(lng)}"
  end

  def query
    "units=e"
  end
end

end

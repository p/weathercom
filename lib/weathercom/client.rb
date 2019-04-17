module Weathercom

class Client
  class ApiError < StandardError
    def initialize(message, status: nil)
      super(message)
      @status = status
    end

    attr_reader :status
  end

  def initialize(api_key: nil, cache_path: nil)
    @configured_api_key = api_key
    @connection ||= Faraday.new("https://api.weather.com") do |f|
      f.request :url_encoded
      #f.response :detailed_logger
      f.adapter Faraday.default_adapter
      f.headers['user-agent'] = 'Weathercom'
    end
  end

  attr_reader :configured_api_key
  attr_reader :connection

  def api_key
    configured_api_key or begin
    end
  end

  def get_json(url)
    request_json(:get, url)
  end

  def request_json(meth, url, params=nil)
    response = connection.send(meth) do |req|
      req.url(url)
    end
    unless response.status == 200
      error = nil
      begin
        error = JSON.parse(response.body)['error']
      rescue
      end
      msg = "Weathercom #{meth.to_s.upcase} #{url} failed: #{response.status}"
      if error
        msg += ": #{error}"
      end
      raise ApiError.new(msg, status: response.status)
    end
    JSON.parse(response.body)
  end

  # endpoints

  def geocode(location_str)
  end

  def location(lat, lng)
    Location.new(lat, lng, self)
  end
end

end

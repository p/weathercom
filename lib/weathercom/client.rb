module Weathercom

class Client
  class ApiError < StandardError
    def initialize(message, status: nil)
      super(message)
      @status = status
    end

    attr_reader :status
  end

  class ApiKeyScrapeError < StandardError
  end

  def initialize(api_key: nil, cache: nil)
    @configured_api_key = api_key
    @cache = cache
    @connection ||= Faraday.new("https://api.weather.com") do |f|
      f.request :url_encoded
      #f.response :detailed_logger
      f.adapter Faraday.default_adapter
      f.headers['user-agent'] = 'Mozilla/5.0 (Compatible)'
    end
    if api_key.nil?
      @api_key = cache.get('weathercom:api_key')
    end
  end

  attr_reader :configured_api_key
  attr_reader :connection

  def api_key
    configured_api_key or begin
      @api_key ||= scrape_api_key
      if @cache
        @cache.set('weathercom:api_key', @api_key)
      end
      @api_key
    end
  end

  private def clear_api_key
    @api_key = nil
    if @cache
      @cache.set('weathercom:api_key', nil)
    end
  end

  def get_json(url)
    request_json(:get, url)
  end

  def request_json(meth, url)
    attempt = 1
    loop do
      if url.include?('?')
        full_url = "#{url}&apiKey=#{URI.encode(api_key)}"
      else
        full_url = "#{url}?apiKey=#{URI.encode(api_key)}"
      end

      response = connection.send(meth) do |req|
        req.url(full_url)
      end
      if response.status == 401 && configured_api_key.nil? && attempt == 1
        clear_api_key
        attempt += 1
        next
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
      return JSON.parse(response.body)
    end
  end

  def request_json_with_cache(meth, url)
    cache_key = "weathercom:#{meth}:#{url}"
    if @cache && (data = @cache.get(cache_key))
      if data.key?('metadata') && data['metadata'].key?('expire_time_gmt') &&
        data['metadata']['expire_time_gmt'] > Time.now.to_i
      then
        return data
      end
      @cache.set(cache_key, nil)
    end

    request_json(meth, url).tap do |data|
      if @cache
        @cache.set(cache_key, data)
      end
    end
  end

  # endpoints

  def geocode(query, ttl: nil)
    if @cache && ttl
      cache_key = "weathercom:geocode:#{query}"
      result = @cache.get(cache_key)
      if result && result['expires_at'] && result['expires_at'] > Time.now.to_i
        return GeocodedLocation.new(result['location'], self)
      end
    end

    payload = raw_geocode(query)

    if @cache && ttl
      @cache.set(cache_key, 'expires_at' => Time.now.to_i + ttl, 'location' => payload)
    end

    GeocodedLocation.new(payload, self)
  end

  def location(lat, lng)
    Location.new(lat, lng, self)
  end

  private

  API_KEY_URL = "https://www.wunderground.com/weather/us/ny/new-york"

  def scrape_api_key
    resp = connection.get(API_KEY_URL)
    if resp.status != 200
      raise ApiKeyScrapeError, "Non-200 status while scraping API key: #{resp.status}"
    end

    unless resp.body =~ /apiKey=([a-zA-Z0-9]{10,})/
      raise ApiKeyScrapeError, "Could not locate API key in response"
    end

    $1
  end

  def raw_geocode(query)
    url = "/v3/location/search?language=EN&query=#{URI.encode(query)}&format=json"
    payload = get_json(url)
    payload = Hash[payload['location'].map do |key, values|
      [key, values.first]
    end]
  end
end

end

module Weathercom

module ForecastMethods

  def wc_class
    @info['class']
  end

  def expires_at
    @expires_at ||= Time.at(expire_time_gmt)
  end

end

end

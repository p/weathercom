module Weathercom

class Observation
  include ForecastMethods

  def initialize(info, metadata)
    @info = info.dup.freeze
    @metadata = metadata
  end

  attr_reader :metadata

  %w(
    expire_time_gmt obs_time obs_time_local
    day_ind dow
    obs_qualifier_code obs_qualifier_severity
    ptend_code ptend_desc sky_cover clds
    wdir wdir_cardinal
    icon_code icon_extd wxman
    sunrise sunset
    uv_index uv_warning uv_desc
    phrase_12char phrase_22char phrase_32char
    vocal_key imperial
  ).each do |m|
    define_method(m) do
      @info[m]
    end
  end

  def sunrise_at
    Time.parse(sunrise)
  end

  def sunset_at
    Time.parse(sunset)
  end

  def day?
    day_ind == 'Y'
  end

  %w(wspd gust vis mslp altimeter temp dewpt rh wc hi temp_change_24hour
    temp_max_24hour temp_min_24hour pchange feels_like snow_1hour snow_6hour
    snow_24hour snow_7day ceiling precip_1hour precip_6hour precip_24hour
    precip_mtd precip_ytd precip_2day precip_3day precip_7day obs_qualifier_100char
    obs_qualifier_50char obs_qualifier_32char
  ).each do |m|
    define_method(m) do
      @info['imperial'][m]
    end
  end

end

end

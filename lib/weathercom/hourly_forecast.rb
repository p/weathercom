module Weathercom

class HourlyForecast
  include ForecastMethods

  def initialize(info, metadata)
    @info = info.dup.freeze
    @metadata = metadata
  end

  attr_reader :metadata

  %w(
    expire_time_gmt fcst_valid fcst_valid_local
    num day_ind dow
    temp feels_like dewpt pop precip_type severity
    hi wc qpf snow_qpf rh wspd wdir wdir_cardinal gust clds vis mslp
    uv_index_raw uv_index uv_warning uv_desc golf_index golf_category
    icon_extd wxman icon_code
    phrase_12char phrase_22char phrase_32char
    subphrase_pt1 subphrase_pt2 subphrase_pt3
  ).each do |m|
    define_method(m) do
      @info[m]
    end
  end

end

end

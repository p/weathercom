module Weathercom

class Observation
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

  def wc_class
    @info['class']
  end
end

end

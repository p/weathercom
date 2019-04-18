module Weathercom

class DailyForecast
  def initialize(info, metadata)
    @info = info.dup.freeze
    @metadata = metadata
  end

  attr_reader :metadata

  %w(expire_time_gmt fcst_valid fcst_valid_local
    num dow night
    max_temp min_temp
    torcon stormcon
    blurb blurb_author narrative
    qualifier_code qualifier
    qpf snow_qpf snow_range snow_phrase snow_code
    lunar_phase_day lunar_phase_code sunrise sunset moonrise moonset
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

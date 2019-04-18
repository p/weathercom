module Weathercom

class WwirForecast
  def initialize(info, metadata)
    @info = info.dup.freeze
    @metadata = metadata
  end

  attr_reader :metadata

  %w(
    expire_time_gmt fcst_valid fcst_valid_local
    overall_type phrase terse_phrase phrase_template terse_phrase_template
    precip_day precip_time_24hr precip_time_12hr precip_time_iso time_zone_abbrv
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

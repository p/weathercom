module Weathercom

class DayPartForecast

  def initialize(info)
    @info = info.dup.freeze
  end

  %w(
    fcst_valid fcst_valid_local
    day_ind thunder_enum
    daypart_name long_daypart_name alt_daypart_name
    thunder_enum_phrase
    num temp hi wc rh icon_extd icon_code wxman
    phrase_12char phrase_22char phrase_32char
    subphrase_pt1 subphrase_pt2 subphrase_pt3
    pop precip_type
    wspd wdir wdir_cardinal
    clds
    pop_phrase temp_phrase accumulation_phrase wind_phrase
    shortcast narrative
    qpf snow_qpf
    snow_range snow_phrase snow_code
    vocal_key qualifier_code qualifier
    uv_index_raw uv_index uv_warning uv_desc
    golf_index golf_category
  ).each do |m|
    define_method(m) do
      @info[m]
    end
  end

  alias :start_timestamp :fcst_valid
  alias :precip_probability :pop

end

end

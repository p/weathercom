module Weathercom

class Metadata

  def initialize(info)
    @info = info.dup.freeze
  end

  %w(
    language transaction_id version latitude longitude expire_time_gmt status_code
  ).each do |m|
    define_method(m) do
      @info[m]
    end
  end

  alias :lat :latitude
  alias :lng :longitude

  def expires_at
    @expires_at ||= Time.at(expire_time_gmt)
  end

end

end

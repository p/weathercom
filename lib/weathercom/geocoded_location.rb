module Weathercom

class GeocodedLocation < Location
  def initialize(info, client)
    info = info.dup
    super(info.delete('latitude'), info.delete('longitude'), client)
    @info = info.freeze
  end

  %w(address admin_district admin_district_code city country country_code
    display_name iana_time_zone locale neighborhood place_id postal_code
    postal_key disputed_area loc_id location_category pws_id type
  ).each do |m|
    key = m.gsub(/_(\w)/) { |match| $1.upcase }
    define_method(m) do
      @info[key]
    end
  end

  alias :state_name :admin_district
  alias :state_abbr :admin_district_code
  alias :zipcode :postal_code
end

end

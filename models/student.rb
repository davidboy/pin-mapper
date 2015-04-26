require 'sequel'
require 'json'

class Student < Sequel::Model
  def before_save
    super

    latitude, longitude = reverse_geocode self.city

    self.gps_lat = latitude
    self.gps_lon = longitude
  end

  private

  # Looks up the GPS coordinates of a location
  #
  # @param [String] location A string describing the location (for example, an
  #   address, zip code, or city name)
  # @return [Array<(Float, Float)>] The latitude and longitude of the location
  #
  # @todo Handle errors gracefully (malformed data, api being down, etc.)
  # @todo Blindly using the first coordinates found might be a bad idea?
  def reverse_geocode(location)
    sanitized_location = URI.escape(location)
    api_uri = URI.parse("http://nominatim.openstreetmap.org/search/#{sanitized_location}?format=json")

    city_data = JSON.parse(Net::HTTP.get(api_uri)).first

    latitude  = city_data['lat'].to_f
    longitude = city_data['lon'].to_f

    return [latitude, longitude]
  end
end
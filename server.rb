require 'sinatra'
require 'sequel'
require 'json'

require 'net/http'

DB = Sequel.sqlite 'data.db'

# DB.create_table :students do
#   primary_key :id
#   String :name
#   String :city
#   Float :gps_lat  # N
#   Float :gps_lon  # W
# end

get '/hi' do 
  "Hello world!"
end

get '/' do
  @students = DB[:students].all
  @cluster  = (params[:cluster] != 'n')

  erb :index
end

post '/students' do
  result = Net::HTTP.get(URI.parse("http://nominatim.openstreetmap.org/search/#{URI.escape(params[:city])}?format=json"))
  
  # FIXME: perhaps blindly using the first returned result might be a bad idea?
  city_data = JSON.parse(result).first

  DB[:students].insert(
    name: params[:name],
    city: params[:city],
    gps_lat: city_data['lat'].to_f,
    gps_lon: city_data['lon'].to_f
  )

  # TODO: handle errors?

  redirect '/'
end
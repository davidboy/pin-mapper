require 'sinatra/base'

class StudentPinMap < Sinatra::Application
  require './models/database'
  initialize_database(settings.production?)

  require './models/student'

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  # Group together adjacent pins?  If multiple pins are in the same location
  #  and this setting is turned off, only the top pin will be shown.
  set cluster: true

  # Use satellite images for the map background?
  set satellite: false

  # To change the above settings, the user clicks a link which sets a URI
  #   parameter (eg. "/?cluster=n").  This before hook checks for those and
  #   updates the setting accordingly.
  before do
    for setting in [:cluster, :satellite]
      if params[setting]
        StudentPinMap.set(setting, params[setting] == 'y')
      end
    end
  end

  # The main page.  Currently displays the map and a form to add another student
  get '/' do
    @students = Student.all

    @cluster   = settings.cluster
    @satellite = settings.satellite

    if @satellite
      @tile_layer = "http://otile1.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.png"
    else
     @tile_layer = "http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png"
   end

    erb :index
  end

  # @todo validation and error checking
  post '/students' do
    Student.create name: params[:name], city: params[:city]

    redirect '/'
  end

  # @todo validation and error checking
  put '/students/:id' do
    Student[params[:id]].update({
      name: params[:name],
      city: params[:city]
    })

    redirect '/'
  end

  # @todo guess what? validation and error checking!
  delete '/students/:id' do
    Student[params[:id]].delete

    redirect '/'
  end

  # TODO: add config.ru to run with rackup
  run!
end
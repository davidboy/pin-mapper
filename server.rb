require 'sinatra/base'
require 'rack/csrf'

class StudentPinMap < Sinatra::Application
  # Restrict access so random people on the internet won't delete the map
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'covenant' and password == ENV['ACCESS_PASSWORD']
  end

  # We don't use sessions, but they are needed by the CSRF protection module
  enable :sessions
  use Rack::Csrf, raise: true

  # Connect to the database and load the student model
  require './models/database'
  initialize_database(settings.production?)
  require './models/student'

  # Group together adjacent pins?  If multiple pins are in the same location
  #  and this setting is turned off, only the top pin will be shown.
  set cluster: true

  # To change the cluster setting, the user clicks a link which sets a URI
  #   parameter.  So we check for that and change the setting accordingly.
  before do
    if params[:cluster]
      StudentPinMap.set(:cluster, params[:cluster] == 'y')
    end
  end

  # The main page.  Currently displays the map and a form to add another student
  get '/' do
    @cluster  = settings.cluster
    @students = Student.all

    if params[:zoom_to]
      @zoom_to = params[:zoom_to]
    end

    erb :index
  end

  # Adds a new student to the database
  # @todo validation and error checking
  post '/students' do
    new_student = Student.create name: params[:name], city: params[:city]

    redirect "/?zoom_to=#{new_student.id}"
  end

  # Changes the name and/or location of a student
  # @todo validation and error checking
  put '/students/:id' do
    Student[params[:id]].update({
      name: params[:name],
      city: params[:city]
    })

    redirect '/'
  end

  # Removes a student from the map
  # @todo guess what? validation and error checking!
  delete '/students/:id' do
    Student[params[:id]].delete

    redirect '/'
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end
end
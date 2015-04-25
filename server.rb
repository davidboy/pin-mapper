require 'sinatra/base'

require './models/student'

class StudentPinMap < Sinatra::Application
  set :bind, '0.0.0.0'

  get '/' do
    @students = Student.all
    @cluster  = (params[:cluster] != 'n')

    erb :index
  end

  post '/students' do
    Student.create name: params[:name], city: params[:city]

    redirect '/'
  end

  # TODO: add config.ru to run with rackup
  run!
end
require 'sinatra'

require './models/student'

get '/hi' do 
  "Hello world!"
end

get '/' do
  @students = Student.all
  @cluster  = (params[:cluster] != 'n')

  erb :index
end

post '/students' do
  Student.create name: params[:name], city: params[:city]

  redirect '/'
end
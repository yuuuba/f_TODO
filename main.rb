require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'base64'
require_relative 'models/todo'
require_relative 'models/user'
require_relative 'config/db'

enable :sessions
set :bind, '0.0.0.0'
set :session_secret, SecureRandom.hex(32)

get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
  end

  @todos = Todo.all
  erb :todos
end

post '/create_todo' do
  if params['image'] && params['image'][:tempfile]
    image_data = params['image'][:tempfile].read
  end

  # pp params
  Todo.create(
    title: params["title"],
    image_data: image_data
    )

  # @todos = Todo.all
  # erb :todos

  redirect '/'
end

get '/edit/:id' do
  @todo = Todo.find(params[:id])
  erb :edit
end

post '/update/:id' do
  todo = Todo.find(params['id'])
  todo.title = params['title']

  if params['image'] && params['image'][:tempfile]
    todo.image_data = params['image'][:tempfile].read
  end

  todo.save
  redirect "/"
end

post '/delete_image/:id' do
  todo = Todo.find(params['id'])
  todo.update(image_data: nil)
  redirect "/edit/#{todo.id}"
end

delete '/delete_todo/:id' do
  # enable :method_override
  # Todo.destroy(title: params["title"])
  todo = Todo.find(params[:id])
  todo.destroy
  redirect '/'
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(username: params[:username])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    @error = "ユーザーIDかパスワードが間違っています"
    erb :login
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

before '/protected_page' do
  redirect '/login' unless session[:user_id]
end

get '/protected_page' do
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(username: params[:username])
  user.password = params[:password]

  if user.save
    session[:user_id] = user.id
    redirect '/'
  else
    @error = "Failed to create user"
    erb :signup
  end
end

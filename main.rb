require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'base64'
require_relative 'models/todo'
require_relative 'config/db'

set :bind, '0.0.0.0'


get '/' do
  # 'やることリスト'
  # book = Book.new(title: 'たのしい Ruby', author: 'Jhon Doe', price: 1_000)
  # book.save!
  # Book.create(title: 'チェリー本', author: 'itou', price: 3_000)

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

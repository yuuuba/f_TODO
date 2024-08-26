require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
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
  # pp params
  Todo.create(title: params["title"])

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
  todo.save

  redirect "/"
end

delete '/delete_todo/:id' do
  # enable :method_override
  # Todo.destroy(title: params["title"])
  todo = Todo.find(params[:id])
  todo.destroy
  redirect '/'
end

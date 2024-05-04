require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require_relative 'models/book'
require_relative 'config/db'

set :bind, '0.0.0.0'

get '/' do
  Book.all
  'Hello World!!!!'
end

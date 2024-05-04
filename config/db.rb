require 'active_record'
require 'yaml'
require_relative '../models/book'

config = YAML.load_file('./config/db.yml')

ActiveRecord::Base.establish_connection config['development']

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include?('books')
    create_table :books do |table|
      table.column :title,    :string
      table.column :author,  :string
      table.column :price,    :integer
    end
  end
end

require 'active_record'
require 'yaml'
require_relative '../models/todo'

config = YAML.load_file('./config/db.yml')

ActiveRecord::Base.establish_connection config['development']

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include?('todos')
    create_table :todos do |table|
      table.column :title,    :string
    end
  end
end

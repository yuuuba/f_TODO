require 'active_record'
require 'yaml'
require_relative '../models/todo'

config = YAML.load_file('./config/db.yml')

ActiveRecord::Base.establish_connection config['development']

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include?('todos')
    create_table :todos do |table|
      table.column :title,    :string
      table.column :image_data,    :binary
    end
  else
    # 既存のテーブルにカラムを追加
    change_table :todos do |table|
      unless column_exists?(:todos, :image_data)
        table.column :image_data, :binary
      end
    end
  end

  unless ActiveRecord::Base.connection.tables.include?('users')
    create_table :users do |table|
      table.column :username, :string
      table.column :password_digest, :string
    end
  end
end

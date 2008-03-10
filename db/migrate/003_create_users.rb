require 'active_record/fixtures'

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name

      t.timestamps
    end

    directory = File.join(File.dirname(__FILE__), 'default_data')
    Fixtures.create_fixtures(directory, 'users')

  end

  def self.down
    drop_table :users
  end
end

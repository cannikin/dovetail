require 'active_record/fixtures'

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.integer :state_id
      t.integer :country_id
      t.string :postal_code
      t.string :email
      t.string :phone
      t.string :login
      t.string :password
      t.string :uuid
      t.datetime :previous_login_at
      t.datetime :last_login_at
      t.datetime :last_login_from

      t.timestamps
    end
    
    add_index :users, :login
    add_index :users, [:login, :password]
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "users")
    
  end

  def self.down
    drop_table :users
  end
end

require 'active_record/fixtures'

# I made user/site a has_many :through relationship so that multiple users could own/admin a site

class CreateOwnerships < ActiveRecord::Migration
  def self.up
    create_table :ownerships do |t|
      t.integer :site_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :ownerships, :site_id
    add_index :ownerships, :user_id
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "ownerships")
  end

  def self.down
    drop_table :ownerships
  end
end

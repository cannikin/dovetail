require 'active_record/fixtures'

class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.string :description
      t.string :subdomain
      t.integer :variant_id
      t.boolean :enabled, :default => true

      t.timestamps
    end
    
    add_index :sites, :subdomain, :unique => true
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "sites")
    
  end

  def self.down
    drop_table :sites
  end
end

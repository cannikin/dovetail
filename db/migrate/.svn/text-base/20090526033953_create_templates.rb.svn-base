require 'active_record/fixtures'

class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.text :description
      t.string :stylesheets
      t.boolean :default, :default => false

      t.timestamps
    end
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "templates")
    
  end

  def self.down
    drop_table :templates
  end
end

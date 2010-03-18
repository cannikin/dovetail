require 'active_record/fixtures'

class CreateParts < ActiveRecord::Migration
  def self.up
    create_table :parts do |t|
      t.integer :page_id
      t.text :content
      t.integer :position
      t.integer :part_type_id
      t.boolean :visible, :default => true
      
      t.timestamps
    end
    
    add_index :parts, :page_id
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "parts")
    
  end

  def self.down
    drop_table :parts
  end
end

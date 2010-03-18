require 'active_record/fixtures'

class CreatePartTypes < ActiveRecord::Migration
  def self.up
    create_table :part_types do |t|
      t.string :name        # for the user to pick which type they want
      t.string :class_name  # CSS class
      t.text :description   
      t.text :code          # Default code to populate a new "instance" of this part
      t.integer :position   # Position on the pag
      t.boolean :default, :default => false
      
      t.timestamps
    end
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "part_types")
    
  end

  def self.down
    drop_table :part_types
  end
end

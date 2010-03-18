require 'active_record/fixtures'

class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.integer :template_id
      t.string :name
      t.text :description
      t.string :stylesheet
      t.boolean :default, :default => false
      t.integer :position

      t.timestamps
    end
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "variants")
    
  end

  def self.down
    drop_table :variants
  end
end

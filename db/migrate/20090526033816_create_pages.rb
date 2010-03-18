require 'active_record/fixtures'

class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :site_id
      t.string :name
      t.string :title
      t.string :slug
      t.boolean :visible, :default => true
      t.integer :position

      t.timestamps
    end
    
    add_index :pages, :site_id
    add_index :pages, :slug
    
    directory = File.join(File.dirname(__FILE__), "default_data") 
    Fixtures.create_fixtures(directory, "pages")
    
  end

  def self.down
    drop_table :pages
  end
end

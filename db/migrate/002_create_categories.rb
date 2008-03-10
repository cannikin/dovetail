require 'active_record/fixtures'

class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, :url
      t.integer :parent_id

      t.timestamps
    end

    directory = File.join(File.dirname(__FILE__), 'default_data')
    Fixtures.create_fixtures(directory, 'categories')

  end

  def self.down
    drop_table :categories
  end
end

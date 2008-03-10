require 'active_record/fixtures'

class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :location
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end

    directory = File.join(File.dirname(__FILE__), 'default_data')
    Fixtures.create_fixtures(directory, 'ads')

  end

  def self.down
    drop_table :ads
  end
end

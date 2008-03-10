require 'active_record/fixtures'

class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :filename
      t.integer :ad_id

      t.timestamps
    end

    directory = File.join(File.dirname(__FILE__), 'default_data')
    Fixtures.create_fixtures(directory, 'images')

  end

  def self.down
    drop_table :images
  end
end

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "ads", :force => true do |t|
    t.string   "title",       :default => "NULL"
    t.text     "description", :default => "NULL"
    t.decimal  "price",       :default => 0.0
    t.string   "location",    :default => "NULL"
    t.integer  "user_id",     :default => 0
    t.integer  "category_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :default => "NULL"
    t.string   "url",        :default => "NULL"
    t.integer  "parent_id",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "filename",   :default => "NULL"
    t.integer  "ad_id",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",       :default => "NULL"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

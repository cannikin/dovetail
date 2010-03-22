# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090830204315) do

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "ownerships", :force => true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ownerships", ["site_id"], :name => "index_ownerships_on_site_id"
  add_index "ownerships", ["user_id"], :name => "index_ownerships_on_user_id"

  create_table "pages", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "title"
    t.string   "slug"
    t.boolean  "visible",    :default => true
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["site_id"], :name => "index_pages_on_site_id"
  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "part_types", :force => true do |t|
    t.string   "name"
    t.string   "class_name"
    t.text     "description"
    t.text     "code"
    t.integer  "position"
    t.boolean  "default",     :default => false
    t.boolean  "enabled",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", :force => true do |t|
    t.integer  "page_id"
    t.text     "content"
    t.integer  "position"
    t.integer  "part_type_id"
    t.boolean  "visible",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parts", ["page_id"], :name => "index_parts_on_page_id"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "subdomain"
    t.integer  "variant_id"
    t.boolean  "enabled",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["subdomain"], :name => "index_sites_on_subdomain", :unique => true

  create_table "states", :force => true do |t|
    t.string  "name"
    t.integer "country_id"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "stylesheets"
    t.boolean  "default",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.integer  "state_id"
    t.integer  "country_id"
    t.string   "postal_code"
    t.string   "email"
    t.string   "phone"
    t.string   "login"
    t.string   "password"
    t.string   "uuid"
    t.datetime "previous_login_at"
    t.datetime "last_login_at"
    t.datetime "last_login_from"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login", "password"], :name => "index_users_on_login_and_password"
  add_index "users", ["login"], :name => "index_users_on_login"

  create_table "variants", :force => true do |t|
    t.integer  "template_id"
    t.string   "name"
    t.text     "description"
    t.string   "stylesheet"
    t.boolean  "default",     :default => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

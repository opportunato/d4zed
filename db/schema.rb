# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151130121421) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string   "name"
    t.string   "director"
    t.string   "music"
    t.string   "vimeo_id"
    t.text     "description"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_published", default: false
    t.string   "bg_color",     default: "af4e7b"
    t.integer  "size",         default: 0
    t.integer  "order_number", default: 0
    t.string   "link"
  end

  create_table "credits", force: :cascade do |t|
    t.string   "person"
    t.integer  "position_id"
    t.integer  "medium_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_number", default: 0
  end

  create_table "media", force: :cascade do |t|
    t.string   "name"
    t.integer  "brand_id"
    t.string   "director"
    t.string   "music"
    t.string   "vimeo_id"
    t.string   "link"
    t.text     "description"
    t.string   "thumbnail"
    t.boolean  "is_published", default: false
    t.integer  "order_number", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.text     "content"
    t.string   "picture"
    t.boolean  "is_published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.text     "text"
    t.integer  "category",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: :cascade do |t|
    t.string   "name"
    t.boolean  "singular",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rich_rich_files", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        default: "file"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kind",       default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",         null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end

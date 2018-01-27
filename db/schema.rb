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

ActiveRecord::Schema.define(version: 20180127220843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cloudinary_images", force: :cascade do |t|
    t.string   "identifier"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "source"
    t.boolean  "topped"
    t.string   "comment_url"
    t.string   "redirect_url"
    t.integer  "tweet_count"
    t.integer  "word_count"
    t.boolean  "hn_status"
  end

  add_index "items", ["url"], name: "index_items_on_url", unique: true, using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "identifier"
    t.string   "sources"
    t.datetime "completed_to"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "read_count"
  end

end

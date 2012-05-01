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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120429102445) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "name_downcase"
    t.string   "wiki"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "m_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "musics", :force => true do |t|
    t.integer  "artist_id"
    t.string   "addr"
    t.string   "name"
    t.string   "name_downcase"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "m_group_id"
  end

  add_index "musics", ["artist_id"], :name => "index_musics_on_artist_id"
  add_index "musics", ["m_group_id"], :name => "index_musics_on_m_group_id"

  create_table "ranking_groups", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rankings", :force => true do |t|
    t.integer  "music_id"
    t.integer  "ranking_group_id"
    t.integer  "ranking"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "rankings", ["ranking"], :name => "index_rankings_on_ranking"

end

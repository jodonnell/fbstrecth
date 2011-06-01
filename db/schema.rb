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

ActiveRecord::Schema.define(:version => 20110531044343) do

  create_table "families", :force => true do |t|
    t.integer  "fbid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", :force => true do |t|
    t.integer  "fbid"
    t.string   "name"
    t.string   "pic"
    t.integer  "gender_id"
    t.string   "profile_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", :force => true do |t|
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "create_time"
    t.boolean  "active"
    t.boolean  "emailed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "fbid"
    t.string   "email"
    t.string   "username"
    t.integer  "gender_id"
    t.integer  "interested_in_id"
    t.string   "access_token"
    t.integer  "friends_id"
    t.integer  "interested_in_local_id"
    t.integer  "myself_friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

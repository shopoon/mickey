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

ActiveRecord::Schema.define(version: 20140630072437) do

  create_table "couples", force: true do |t|
    t.integer  "mother_id"
    t.integer  "father_id"
    t.datetime "mated_at"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "families", force: true do |t|
    t.string   "number"
    t.string   "genotype"
    t.date     "birth"
    t.integer  "mother_id"
    t.integer  "father_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "families", ["number", "genotype"], name: "index_families_on_number_and_genotype", unique: true

  create_table "mice", force: true do |t|
    t.integer  "family_id"
    t.string   "sex"
    t.integer  "sequence_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mice", ["family_id", "sex", "sequence_id"], name: "index_mice_on_family_id_and_sex_and_sequence_id", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login_id"
    t.string   "role"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login_id"], name: "index_users_on_login_id", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

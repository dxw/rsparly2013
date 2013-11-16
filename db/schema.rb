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

ActiveRecord::Schema.define(version: 20131116200318) do

  create_table "clauses", force: true do |t|
    t.text     "text"
    t.integer  "no",              default: 0
    t.integer  "crossheading_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crossheadings", force: true do |t|
    t.text     "title"
    t.integer  "no",             default: 0
    t.integer  "legislation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legislations", force: true do |t|
    t.text     "title"
    t.date     "passed_on"
    t.date     "proposed_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

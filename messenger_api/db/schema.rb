# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_12_134658) do

  create_table "messages", force: :cascade do |t|
    t.integer "from_user_id", null: false
    t.integer "to_user_id", null: false
    t.string "content", limit: 1000, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["from_user_id", "to_user_id", "created_at"], name: "index_messages_on_from_user_id_and_to_user_id_and_created_at"
    t.index ["from_user_id"], name: "index_messages_on_from_user_id"
    t.index ["to_user_id", "from_user_id", "created_at"], name: "index_messages_on_to_user_id_and_from_user_id_and_created_at"
    t.index ["to_user_id"], name: "index_messages_on_to_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 16
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "messages", "users", column: "from_user_id"
  add_foreign_key "messages", "users", column: "to_user_id"
end

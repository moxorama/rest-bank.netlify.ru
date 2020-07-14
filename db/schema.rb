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

ActiveRecord::Schema.define(version: 2020_07_14_175352) do

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "account_number"
    t.decimal "balance", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", default: 0
    t.index ["account_number"], name: "index_accounts_on_account_number"
  end

  create_table "transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "reason_type"
    t.string "reason_id"
    t.bigint "account_id"
    t.decimal "amount", precision: 10
    t.string "state"
    t.string "transaction_uuid"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["state"], name: "index_transactions_on_state"
  end

  create_table "transfers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "source_id"
    t.bigint "destination_id"
    t.string "state"
    t.decimal "amount", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "initial_source_balance"
    t.integer "initial_destination_balance"
    t.integer "final_source_balance"
    t.integer "final_destination_balance"
    t.index ["destination_id"], name: "index_transfers_on_destination_id"
    t.index ["source_id"], name: "index_transfers_on_source_id"
    t.index ["state"], name: "index_transfers_on_state"
  end

end

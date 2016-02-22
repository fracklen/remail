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

ActiveRecord::Schema.define(version: 20160222102005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "administrators", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "administrators", ["email"], name: "index_administrators_on_email", unique: true, using: :btree
  add_index "administrators", ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true, using: :btree

  create_table "campaign_runs", force: :cascade do |t|
    t.integer  "campaign_id"
    t.uuid     "uuid",             default: "uuid_generate_v4()"
    t.string   "name"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "state"
    t.integer  "total_recipients"
    t.integer  "sent",             default: 0
    t.string   "breakpoint"
    t.string   "last_error"
    t.datetime "deleted_at"
    t.integer  "rejected",         default: 0
    t.integer  "processed",        default: 0
  end

  add_index "campaign_runs", ["campaign_id"], name: "index_campaign_runs_on_campaign_id", using: :btree
  add_index "campaign_runs", ["uuid"], name: "index_campaign_runs_on_uuid", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.integer  "recipient_list_id"
    t.integer  "customer_id"
    t.integer  "domain_id"
    t.string   "name"
    t.uuid     "uuid",              default: "uuid_generate_v4()"
    t.datetime "deleted_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "template_id"
    t.string   "from_email"
    t.string   "reply_to_email"
  end

  add_index "campaigns", ["customer_id"], name: "index_campaigns_on_customer_id", using: :btree
  add_index "campaigns", ["domain_id"], name: "index_campaigns_on_domain_id", using: :btree
  add_index "campaigns", ["recipient_list_id"], name: "index_campaigns_on_recipient_list_id", using: :btree
  add_index "campaigns", ["template_id"], name: "index_campaigns_on_template_id", using: :btree
  add_index "campaigns", ["uuid"], name: "index_campaigns_on_uuid", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.uuid     "uuid",       default: "uuid_generate_v4()"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "deleted_at"
  end

  add_index "customers", ["name"], name: "index_customers_on_name", unique: true, using: :btree
  add_index "customers", ["uuid"], name: "index_customers_on_uuid", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "domains", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "domains", ["customer_id", "name", "deleted_at"], name: "index_domains_on_customer_id_and_name_and_deleted_at", unique: true, using: :btree
  add_index "domains", ["customer_id"], name: "index_domains_on_customer_id", using: :btree

  create_table "recipient_list_uploads", force: :cascade do |t|
    t.binary   "csv_data"
    t.integer  "recipient_list_id"
    t.integer  "created_by_id"
    t.string   "state"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "recipient_list_uploads", ["created_by_id"], name: "index_recipient_list_uploads_on_created_by_id", using: :btree
  add_index "recipient_list_uploads", ["recipient_list_id"], name: "index_recipient_list_uploads_on_recipient_list_id", using: :btree

  create_table "recipient_lists", force: :cascade do |t|
    t.integer  "customer_id"
    t.uuid     "uuid",        default: "uuid_generate_v4()"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "templates", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.string   "subject"
    t.text     "body"
    t.datetime "deleted_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "example_recipient"
  end

  add_index "templates", ["customer_id"], name: "index_templates_on_customer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.integer  "customer_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "campaign_runs", "campaigns"
  add_foreign_key "campaigns", "customers"
  add_foreign_key "campaigns", "domains"
  add_foreign_key "campaigns", "recipient_lists"
  add_foreign_key "campaigns", "templates"
  add_foreign_key "domains", "customers"
  add_foreign_key "recipient_list_uploads", "recipient_lists"
  add_foreign_key "templates", "customers"
end

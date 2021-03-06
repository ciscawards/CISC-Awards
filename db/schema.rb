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

ActiveRecord::Schema.define(version: 20180617172547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string   "url"
    t.integer  "submission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["submission_id"], name: "index_attachments_on_submission_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "cohort_id"
    t.boolean  "always_selected"
    t.index ["cohort_id"], name: "index_categories_on_cohort_id", using: :btree
  end

  create_table "cohorts", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "new_submission_cutoff_date"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "active",                        default: false
    t.datetime "steel_work_completed_deadline"
    t.datetime "edit_submission_cutoff_date"
  end

  create_table "submission_categories", force: :cascade do |t|
    t.string   "description"
    t.integer  "category_id"
    t.integer  "submission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["category_id"], name: "index_submission_categories_on_category_id", using: :btree
    t.index ["submission_id"], name: "index_submission_categories_on_submission_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "cohort_id"
    t.integer  "user_id"
    t.string   "description"
    t.string   "name"
    t.boolean  "submitted"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "project_location"
    t.string   "cisc_member"
    t.boolean  "contact_cisc",              default: false
    t.datetime "steelwork_completion_date"
    t.string   "brief_description"
    t.index ["cohort_id"], name: "index_submissions_on_cohort_id", using: :btree
    t.index ["user_id"], name: "index_submissions_on_user_id", using: :btree
  end

  create_table "team_members", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "title"
    t.integer  "submission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["submission_id"], name: "index_team_members_on_submission_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "role",              default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "website_configurations", force: :cascade do |t|
    t.string   "site_intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attachments", "submissions"
  add_foreign_key "categories", "cohorts"
  add_foreign_key "submission_categories", "categories"
  add_foreign_key "submission_categories", "submissions"
  add_foreign_key "team_members", "submissions"
end

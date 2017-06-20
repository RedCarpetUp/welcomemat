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

ActiveRecord::Schema.define(version: 20170620135041) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applicant_messages", force: :cascade do |t|
    t.text "content"
    t.boolean "from_applicant"
    t.integer "application_id"
    t.datetime "deleted_at"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["deleted_at"], name: "index_applicant_messages_on_deleted_at"
  end

  create_table "applications", force: :cascade do |t|
    t.text "description"
    t.string "name"
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "email"
    t.jsonb "extra_fields", default: {}
    t.string "status"
    t.index ["deleted_at"], name: "index_applications_on_deleted_at"
  end

  create_table "extra_applicant_emails", force: :cascade do |t|
    t.string "email"
    t.boolean "is_greyed", default: false
    t.integer "application_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_extra_applicant_emails_on_deleted_at"
  end

  create_table "jobs", force: :cascade do |t|
    t.text "description"
    t.string "name"
    t.integer "organisation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "fields", default: [], array: true
    t.index ["deleted_at"], name: "index_jobs_on_deleted_at"
  end

  create_table "jobs_collaborators", id: false, force: :cascade do |t|
    t.integer "job_id"
    t.integer "collaborator_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.text "description"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "owner_id"
    t.index ["deleted_at"], name: "index_organisations_on_deleted_at"
  end

  create_table "templates", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.string "name"
    t.integer "organisation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["deleted_at"], name: "index_templates_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

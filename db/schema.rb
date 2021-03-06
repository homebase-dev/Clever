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

ActiveRecord::Schema.define(version: 20161201154314) do

  create_table "answers", force: true do |t|
    t.text     "text"
    t.boolean  "correct"
    t.integer  "question_id"
    t.integer  "creator_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["creator_id"], name: "index_answers_on_creator_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "assignations", force: true do |t|
    t.integer  "test_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignations", ["question_id"], name: "index_assignations_on_question_id", using: :btree
  add_index "assignations", ["test_id"], name: "index_assignations_on_test_id", using: :btree

  create_table "blog_entries", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.boolean  "published"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_entries", ["user_id"], name: "index_blog_entries_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "quiz_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.boolean  "single_question_select"
  end

  add_index "categories", ["creator_id"], name: "index_categories_on_creator_id", using: :btree
  add_index "categories", ["quiz_id"], name: "index_categories_on_quiz_id", using: :btree

  create_table "checks", force: true do |t|
    t.integer  "assignation_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checks", ["answer_id"], name: "index_checks_on_answer_id", using: :btree
  add_index "checks", ["assignation_id"], name: "index_checks_on_assignation_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "faqs", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.boolean  "published"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount",                     precision: 5, scale: 2
    t.string   "message"
    t.string   "transaction_id"
    t.string   "transaction_code"
    t.string   "transaction_text"
    t.boolean  "success"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "membership_expiration_date"
  end

  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "novelties", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.boolean  "published"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "question_contexts", force: true do |t|
    t.text     "content"
    t.integer  "category_id"
    t.integer  "creator_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_workflow_id"
    t.decimal  "display_time_minutes", precision: 5, scale: 2
  end

  add_index "question_contexts", ["category_id"], name: "index_question_contexts_on_category_id", using: :btree
  add_index "question_contexts", ["creator_id"], name: "index_question_contexts_on_creator_id", using: :btree
  add_index "question_contexts", ["test_workflow_id"], name: "index_question_contexts_on_test_workflow_id", using: :btree

  create_table "questions", force: true do |t|
    t.text     "text"
    t.integer  "creator_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "solution"
    t.integer  "question_context_id"
  end

  add_index "questions", ["creator_id"], name: "index_questions_on_creator_id", using: :btree
  add_index "questions", ["question_context_id"], name: "index_questions_on_question_context_id", using: :btree

  create_table "quizzes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "creator_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "quizzes", ["creator_id"], name: "index_quizzes_on_creator_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "test_workflows", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.integer  "user_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_id"
    t.string   "description"
    t.integer  "available_time_sec"
    t.integer  "test_type",                                  default: 0
    t.decimal  "userscore_percent",  precision: 5, scale: 2
  end

  add_index "tests", ["test_id"], name: "index_tests_on_test_id", using: :btree
  add_index "tests", ["user_id"], name: "index_tests_on_user_id", using: :btree

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
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.date     "birthdate"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "blogger"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

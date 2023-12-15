# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_15_131743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "equipements", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_groupes", force: :cascade do |t|
    t.integer "max_count"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "therapist_id", null: false
    t.bigint "service_id", null: false
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.text "commentaire"
    t.index ["service_id"], name: "index_event_groupes_on_service_id"
    t.index ["therapist_id"], name: "index_event_groupes_on_therapist_id"
  end

  create_table "event_individuels", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "therapist_id", null: false
    t.bigint "patient_id", null: false
    t.bigint "ordonnance_id"
    t.bigint "service_id", null: false
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.text "commentaire"
    t.index ["ordonnance_id"], name: "index_event_individuels_on_ordonnance_id"
    t.index ["patient_id"], name: "index_event_individuels_on_patient_id"
    t.index ["service_id"], name: "index_event_individuels_on_service_id"
    t.index ["therapist_id"], name: "index_event_individuels_on_therapist_id"
  end

  create_table "event_personels", force: :cascade do |t|
    t.boolean "is_paid_holiday"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "therapist_id", null: false
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.index ["therapist_id"], name: "index_event_personels_on_therapist_id"
  end

  create_table "firms", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "address"
    t.text "acces_detail"
  end

  create_table "ordonnances", force: :cascade do |t|
    t.date "date_prescription"
    t.integer "num_of_session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "prescripteur_id", null: false
    t.bigint "patient_id", null: false
    t.text "commentaire"
    t.string "title"
    t.text "physiotherapy_objectiv"
    t.text "treatment_plan"
    t.text "progress_notes"
    t.string "diagnostic"
    t.string "type_of_ordonnance"
    t.boolean "is_domicile", default: false
    t.index ["patient_id"], name: "index_ordonnances_on_patient_id"
    t.index ["prescripteur_id"], name: "index_ordonnances_on_prescripteur_id"
  end

  create_table "patient_event_groupes", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id", null: false
    t.bigint "event_groupe_id", null: false
    t.bigint "ordonnance_id", null: false
    t.index ["event_groupe_id"], name: "index_patient_event_groupes_on_event_groupe_id"
    t.index ["ordonnance_id"], name: "index_patient_event_groupes_on_ordonnance_id"
    t.index ["patient_id"], name: "index_patient_event_groupes_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.text "address"
    t.string "tel1"
    t.string "tel2"
    t.string "contact_name"
    t.string "contact_info"
    t.string "contact_tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.text "commentaire"
    t.text "medical_history"
    t.string "consent_form"
    t.text "emergency_contact_name"
    t.text "emergency_contact_tel"
    t.string "discharge"
    t.string "privacy_acknowledgement"
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "prescripteurs", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mail"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_id", null: false
    t.index ["location_id"], name: "index_rooms_on_location_id"
  end

  create_table "services", force: :cascade do |t|
    t.boolean "active"
    t.string "name"
    t.integer "duration_per_unit"
    t.string "color"
    t.boolean "is_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_short"
  end

  create_table "therapist_services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "therapist_id", null: false
    t.bigint "service_id", null: false
    t.index ["service_id"], name: "index_therapist_services_on_service_id"
    t.index ["therapist_id"], name: "index_therapist_services_on_therapist_id"
  end

  create_table "therapists", force: :cascade do |t|
    t.boolean "is_manager"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "firm_id"
    t.boolean "is_active", default: true
    t.index ["firm_id"], name: "index_therapists_on_firm_id"
    t.index ["user_id"], name: "index_therapists_on_user_id"
  end

  create_table "time_blocks", force: :cascade do |t|
    t.string "week_day"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "week_availability_id", null: false
    t.bigint "room_id", null: false
    t.bigint "equipement_id"
    t.index ["equipement_id"], name: "index_time_blocks_on_equipement_id"
    t.index ["room_id"], name: "index_time_blocks_on_room_id"
    t.index ["week_availability_id"], name: "index_time_blocks_on_week_availability_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false
    t.bigint "therapist_id"
    t.bigint "patient_id"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["patient_id"], name: "index_users_on_patient_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["therapist_id"], name: "index_users_on_therapist_id"
  end

  create_table "video_patients", force: :cascade do |t|
    t.date "valid_form"
    t.date "valid_until"
    t.text "instruction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id", null: false
    t.bigint "video_id", null: false
    t.index ["patient_id"], name: "index_video_patients_on_patient_id"
    t.index ["video_id"], name: "index_video_patients_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "url"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "therapist_id", null: false
    t.index ["therapist_id"], name: "index_videos_on_therapist_id"
  end

  create_table "week_availabilities", force: :cascade do |t|
    t.date "valid_from"
    t.date "valid_until"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "therapist_id", null: false
    t.index ["therapist_id"], name: "index_week_availabilities_on_therapist_id"
  end

  add_foreign_key "event_groupes", "services"
  add_foreign_key "event_groupes", "therapists"
  add_foreign_key "event_individuels", "ordonnances"
  add_foreign_key "event_individuels", "patients"
  add_foreign_key "event_individuels", "services"
  add_foreign_key "event_individuels", "therapists"
  add_foreign_key "event_personels", "therapists"
  add_foreign_key "ordonnances", "patients"
  add_foreign_key "ordonnances", "prescripteurs"
  add_foreign_key "patient_event_groupes", "event_groupes"
  add_foreign_key "patient_event_groupes", "ordonnances"
  add_foreign_key "patient_event_groupes", "patients"
  add_foreign_key "patients", "users"
  add_foreign_key "rooms", "locations"
  add_foreign_key "therapist_services", "services"
  add_foreign_key "therapist_services", "therapists"
  add_foreign_key "therapists", "firms"
  add_foreign_key "therapists", "users"
  add_foreign_key "time_blocks", "equipements"
  add_foreign_key "time_blocks", "rooms"
  add_foreign_key "time_blocks", "week_availabilities"
  add_foreign_key "users", "patients"
  add_foreign_key "users", "therapists"
  add_foreign_key "video_patients", "patients"
  add_foreign_key "video_patients", "videos"
  add_foreign_key "videos", "therapists"
  add_foreign_key "week_availabilities", "therapists"
end

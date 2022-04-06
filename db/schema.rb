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

ActiveRecord::Schema.define(version: 2022_04_06_025854) do

  create_table "job_exec_tests", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "job_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "purchase_schedules", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "사입 요청 api 스케줄링 테이블", force: :cascade do |t|
    t.date "date", null: false, comment: "스케줄 날짜"
    t.string "time", comment: "스케줄 시간"
    t.boolean "enabled", comment: "api 전송 여부"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_purchase_schedules_on_date"
  end

end

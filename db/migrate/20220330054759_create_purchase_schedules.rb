class CreatePurchaseSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_schedules, comment: '사입 요청 api 스케줄링 테이블' do |t|
      t.date :date, null: false, unique: true, index: true, comment: '스케줄 날짜'
      t.string :time, comment: '스케줄 시간'
      t.boolean :enabled, comment: 'api 전송 여부'

      t.timestamps
    end
  end
end

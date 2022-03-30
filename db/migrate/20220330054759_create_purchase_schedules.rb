class CreatePurchaseSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :purchase_schedules do |t|
      t.date :date, null: false, unique: true, index: true
      t.string :time
      t.boolean :enable

      t.timestamps
    end
  end
end

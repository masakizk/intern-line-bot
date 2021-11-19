class CreateWakeupRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :wakeup_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :wakeup_at, null: false

      t.timestamps
    end
  end
end

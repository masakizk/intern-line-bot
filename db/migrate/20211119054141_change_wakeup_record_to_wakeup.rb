class ChangeWakeupRecordToWakeup < ActiveRecord::Migration[6.0]
  def change
    rename_table :wakeup_records, :wakeup
  end
end

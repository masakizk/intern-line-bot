class ChangeWakeupToWakeups < ActiveRecord::Migration[6.0]
  def change
    rename_table :wakeup, :wakeups
  end
end

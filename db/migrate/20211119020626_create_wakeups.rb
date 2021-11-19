class CreateWakeups < ActiveRecord::Migration[6.0]
  def change
    create_table :wakeups do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :wakeup_at, null: false

      t.timestamps
      t.index [:wakeup_at]
    end
  end
end

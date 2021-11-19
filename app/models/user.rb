class User < ApplicationRecord
  has_many :wakeups

  # 利用者の起床時間を記録する
  def save_wakeup(wakeup_at = Time.now)
    Wakeup.create!(user: self, wakeup_at: wakeup_at)
  end

  # 今日の起床時間が記録されているかどうか
  def today_wakeup_saved?
    last_wakeup = wakeups.order(wakeup_at: :desc).first
    unless last_wakeup
      return false
    end

    last_wakeup_date = last_wakeup.wakeup_at.to_date
    last_wakeup_date === Time.now.to_date
  end
end

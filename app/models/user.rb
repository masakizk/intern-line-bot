class User < ApplicationRecord
  has_many :wakeups

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

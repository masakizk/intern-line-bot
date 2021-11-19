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

  # 連続して何日早起きできたか
  def wakeup_early_days
    wakeups_order_by_date = wakeups.order(wakeup_at: :desc)

    prev_day = Time.now
    days = 0
    wakeups_order_by_date.each_with_index do |wakeup, i|
      # 前の日との間隔が１日以上空いていたら、カウントを終了する
      diff_in_sec = prev_day - wakeup.wakeup_at
      diff_in_day = diff_in_sec / (60 * 60 * 24)
      if diff_in_day > 1.0
        prev_day = wakeup.wakeup_at
        break
      end

      # 今日の朝の場合は、連続した日数としてカウントする
      if i == 0 and wakeup.early?
        days += 1
        prev_day = wakeup.wakeup_at
        next
      end

      # 別日の場合は、連続した日数としてカウントする（同じ日の場合は無視する）
      if diff_in_day.to_i == 1 and wakeup.early?
        days += 1
      end

      prev_day = wakeup.wakeup_at
    end

    days
  end
end

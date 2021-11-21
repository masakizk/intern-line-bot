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

  # 今日まで連続して早起きできた日数を取得
  def wakeup_early_days
    days = 0 # 連続で早起きした日数
    prev_wakeup_early_day = nil # 前に早起きした日

    wakeups_order_by_date = wakeups.order(wakeup_at: :desc)
    wakeups_order_by_date.each do |wakeup|
      # 今日まで連日で記録されているかを確認
      if prev_wakeup_early_day == nil
        is_consecutive = wakeup.today?
      else
        diff_in_day = (prev_wakeup_early_day.to_date - wakeup.wakeup_at.to_date).to_i
        is_consecutive = diff_in_day == 1
      end

      # 今日まで連日で記録されてなければ終了
      unless is_consecutive
        break
      end

      if wakeup.early?
        days += 1
        prev_wakeup_early_day = wakeup.wakeup_at
      end
    end

    days
  end
end

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
  def wakeup_early_day_count
    wakeup_early_day_count = 0
    prev_wakeup_early_datetime = nil

    wakeups_order_by_date = wakeups.order(wakeup_at: :desc)
    wakeups_order_by_date.each do |wakeup|
      # 今日まで連日で記録されているかを確認
      if prev_wakeup_early_datetime == nil
        is_consecutive = wakeup.today?
      else
        diff_in_day = (prev_wakeup_early_datetime.to_date - wakeup.wakeup_at.to_date).to_i
        is_consecutive = diff_in_day == 1
      end

      # 今日まで連日で記録されてなければ終了
      unless is_consecutive
        break
      end

      if wakeup.early?
        wakeup_early_day_count += 1
        prev_wakeup_early_datetime = wakeup.wakeup_at
      end
    end

    wakeup_early_day_count
  end
end

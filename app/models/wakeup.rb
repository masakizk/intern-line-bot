class Wakeup < ApplicationRecord
  belongs_to :user

  # 早起きかどうか
  def self.early?(wakeup_at)
    wakeup_at.hour.between?(4, 7)
  end

  # 早起きかどうか
  def early?
    Wakeup.early?(wakeup_at)
  end

  # 今日の記録かどうか
  def today?
    now = Time.now
    now.to_date == wakeup_at.to_date
  end
end

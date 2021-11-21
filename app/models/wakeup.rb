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
end

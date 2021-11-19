class Wakeup < ApplicationRecord
  belongs_to :user

  # 早起きかどうか
  def early?
    wakeup_at.hour.between?(4, 7)
  end
end

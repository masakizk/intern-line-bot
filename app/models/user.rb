class User < ApplicationRecord
  has_many :wakeups

  # LINEのuser idからユーザーを作成する
  def self.create_from_line_user(user_id)
    # LINEユーザーとして登録されていないときのみ、作成する
    if User.exists?(line_user_id: user_id)
      return false
    end

    User.create!(line_user_id: user_id)
  end
end

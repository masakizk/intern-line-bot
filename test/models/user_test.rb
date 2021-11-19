require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "today_wakeup_saved" do
    user = User.create

    # 起床時間が記録されていない場合は false
    assert_not user.today_wakeup_saved?

    # 昨日の起床時間を記録
    yesterday = Time.now.yesterday
    user.save_wakeup(yesterday)
    assert_not user.today_wakeup_saved?

    # 今日の起床時間を記録
    now = Time.now
    user.save_wakeup(now)
    assert user.today_wakeup_saved?
  end
end

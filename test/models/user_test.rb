require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "today_wakeup_saved" do
    user = User.create

    # 起床時間が記録されていない場合は false
    assert_not user.today_wakeup_saved?

    # 昨日の起床時間を記録
    yesterday = Time.now.yesterday
    user.wakeups.create!(wakeup_at: yesterday)
    assert_not user.today_wakeup_saved?

    # 今日の起床時間を記録
    now = Time.now
    user.save_wakeup(now)
    assert user.today_wakeup_saved?
  end

  test "wakeup_early_days" do
    user = User.create

    today_morning = Time.now.change(hour: 7)
    user.wakeups.create!(wakeup_at: today_morning)

    # 同じ日に２回記録されていても、無視する
    today_morning = Time.now.change(hour: 6)
    user.wakeups.create!(wakeup_at: today_morning)

    yesterday_morning = today_morning.ago(1.days)
    user.wakeups.create!(wakeup_at: yesterday_morning)

    assert_equal 2, user.wakeup_early_days
  end

  test "wakeup_early_day_with_not_continuous_days" do
    user = User.create

    today_morning = Time.now.change(hour: 7)
    user.wakeups.create!(wakeup_at: today_morning)

    # 連続して早起きできていなければ、カウントしない
    user.wakeups.create!(wakeup_at: today_morning.ago(2.days))

    assert_equal 1, user.wakeup_early_days
  end

  test "wakeup_early_day_with_not_early" do
    user = User.create

    today_morning = Time.now.change(hour: 7)
    user.wakeups.create!(wakeup_at: today_morning)

    # 連続した日付でも、早起きできていなければカウントしない
    today_afternoon = today_morning.change(hour: 12)
    yesterday_afternoon = today_afternoon.ago(1.days)
    user.wakeups.create!(wakeup_at: yesterday_afternoon)

    assert_equal 1, user.wakeup_early_days
  end

end

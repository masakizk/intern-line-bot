require "minitest/autorun"

describe "UserTest" do
  before do
    @user = User.create
  end

  describe "today_wakeup_saved?" do
    it "今日の起床時間を記録されていない" do
      # 何も記録されていない
      assert_equal false, @user.today_wakeup_saved?

      # 昨日の起床時間が記録されている
      yesterday = Time.zone.now.yesterday
      @user.wakeups.create!(wakeup_at: yesterday)
      assert_equal false, @user.today_wakeup_saved?
    end

    it "今日の起床時間を記録されている" do
      now = Time.zone.now
      @user.wakeups.create!(wakeup_at: now)
      assert_equal true, @user.today_wakeup_saved?
    end
  end
end

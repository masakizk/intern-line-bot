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

  describe "wakeup_early_days" do
    it "連続して早起きした日数をカウントする" do
      today_morning = Time.now.change(hour: 7)
      [
        today_morning,
        today_morning.ago(1.days)
      ].each { |wakeup_at|
        @user.wakeups.create!(wakeup_at: wakeup_at)
      }

      assert_equal 2, @user.wakeup_early_days
    end

    it "連続していても今日が含まれていなければ、カウントしない" do
      today_morning = Time.now.change(hour: 7)
      [
        today_morning.ago(1.days),
        today_morning.ago(2.days)
      ].each { |wakeup_at| @user.wakeups.create!(wakeup_at: wakeup_at) }

      assert_equal 0, @user.wakeup_early_days
    end

    it "同じ日に複数回記録されていても、１回だけカウントする" do
      now = Time.now
      yesterday = now.ago(1.days)
      [
        now.change(hour: 6),
        now.change(hour: 7),
        now.change(hour: 12),
        yesterday.change(hour: 6),
        yesterday.change(hour: 7),
        yesterday.change(hour: 12),
      ].each { |wakeup_at| @user.wakeups.create!(wakeup_at: wakeup_at) }

      assert_equal 1, @user.wakeup_early_days
    end

    it "連続して早起きできていなければ、カウントしない" do
      today_morning = Time.now.change(hour: 7)
      [
        today_morning,
        today_morning.ago(2.days),
      ].each { |wakeup_at| @user.wakeups.create!(wakeup_at: wakeup_at) }

      assert_equal 1, @user.wakeup_early_days
    end

    it "連続した日付でも、早起きできていなければカウントしない" do
      now = Time.now
      wakeup_ats = [
        now.change(hour: 7),
        now.ago(1.days).change(hour: 12),
      ]
      wakeup_ats.each { |wakeup_at| @user.wakeups.create!(wakeup_at: wakeup_at) }

      assert_equal 1, @user.wakeup_early_days
    end
  end
end
